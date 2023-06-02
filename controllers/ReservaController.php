<?php

namespace app\controllers;

use app\models\Informacion;
use app\models\Pago;
use app\models\Plaza;
use app\models\Reserva;
use app\models\Tarifa;
use DateTime;
use Symfony\Polyfill\Intl\Idn\Info;
use Yii;
use yii\data\Pagination;
use yii\helpers\Json;
use yii\web\UploadedFile;

class ReservaController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'index' => ['GET'],
                'create' => ['POST']
            ]
        ];
        return $behaviors;
    }

    public function beforeAction($action)
    {
        if (Yii::$app->getRequest()->getMethod() === 'OPTIONS') {
            Yii::$app->getResponse()->getHeaders()->set('Allow', 'POST GET PUT');
            Yii::$app->end();
        }
        $this->enableCsrfValidation = false;
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        return parent::beforeAction($action);
    }

    public function actionIndex($pageSize = 5)
    {
        $query = Reserva::find()
            ->with('cliente')
            ->with('pagos')
            ->with('tarifa')
            ->with('plaza');

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $requests = $query
            ->orderBy('id DESC')
            ->offset($pagination->offset)
            ->limit($pagination->limit)
            ->asArray()
            ->all();

        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
            'success' => true,
            'message' => 'lista de solicitudes',
            'pageInfo' => [
                'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
                'previus' => $currentPage == 1 ? null : $currentPage - 1,
                'count' => count($requests),
                'page' => $currentPage,
                'start' => $pagination->getOffset(),
                'totalPages' => $totalPages,
            ],
            'requests' => $requests
        ];
        return $response;
    }

    public function actionCreate()
    {
        /* Agregear fecha inicio y fin */
        $information = Informacion::find()->one();
        $reserve = new Reserva();
        $data = Json::decode(Yii::$app->request->post('data'));
        $reserve->load($data, '');
        $fechaActual = new DateTime();
        if ($fechaActual < $information->fecha_inicio_reserva) {
            $reserve->fecha_inicio = $information->fecha_inicio_reserva;
        }
        $reserve->fecha_fin = $data['fecha_fin'];

        if ($reserve->save()) {
            $plaza = Plaza::findOne($data['plaza_id']);
            $plaza->estado = $data['estadoPlaza'];
            if ($plaza->save()) {
                /* Verificar si es reserva por coutas. */
                $pay = new Pago();
                $pay->nro_cuotas_pagadas = $data['monthsPaid']; 
                $pay->reserva_id = $reserve->id;
                $pay->total = $data['total'];
                $pay->tipo_pago = $data['tipo_pago'];
                $pay->estado = false;
                $imgVoucher = UploadedFile::getInstanceByName('img');

                if ($imgVoucher) {
                    $fileName = uniqid() . '.' . $imgVoucher->getExtension();
                    $imgVoucher->saveAs(Yii::getAlias('@app/web/upload/' . $fileName));
                    $pay->comprobante = $fileName;
                }

                if (!$pay->save()) {
                    return [
                        'success' => false,
                        'message' => 'Existen errores en los parametros.',
                        'reserve' => $plaza->errors
                    ];
                }
                $response = [
                    'success' => true,
                    'message' => 'Reserva enviada con exito.',
                    'reserve' => $reserve
                ];
            } else {
                $response = [
                    'success' => false,
                    'message' => 'Existen errores en los parametros.',
                    'reserve' => $plaza->errors
                ];
            }
        } else {
            $response = [
                'success' => false,
                'message' => 'Existen errores en los parametros.',
                'reserve' => $reserve->errors
            ];
        }
        return $response;
    }

    public function actionGetCustomerReserve($idCustomer)
    {
        $reserve = Reserva::find()
            ->where(['cliente_id' => $idCustomer])
            ->with('pagos')
            ->with('tarifa')
            ->with('plaza')
            ->asArray()
            ->one();
        if ($reserve) {
            $response = [
                'success' => true,
                'message' => 'Reserva actual del cliente',
                'infoReserve' => $reserve
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'No existe reserva',
                'infoReserve' => []
            ];
        }
        return $response;
    }

    public function actionConfirmRequest($idRequest)
    {
        $request = Reserva::findOne($idRequest);
        if ($request) {
            $request->estado = 'aprobado';
            $plaza = Plaza::findOne($request->plaza_id);
            $plaza->estado = 'asignado';
            if ($request->save() && $plaza->save()) {
                $response = [
                    'success' => true,
                    'message' => 'Reserva asignada correctamente.'
                ];
            } else {
                $response = [
                    'success' => false,
                    'message' => 'Ocurrio un error.',
                    'errors' => $request->errors
                ];
            }
        }
        return $response;
    }

    public function actionCancelRequest($idRequest)
    {
        $request = Reserva::findOne($idRequest);
        if ($request) {
            $request->estado = 'cancelado';
            $plaza = Plaza::findOne($request->plaza_id);
            $plaza->estado = 'disponible';
            if ($request->save() && $plaza->save()) {
                $response = [
                    'success' => true,
                    'message' => 'Reserva cancelada correctamente.'
                ];
            } else {
                $response = [
                    'success' => false,
                    'message' => 'Ocurrio un error.',
                    'errors' => $request->errors
                ];
            }
        }
        return $response;
    }

    public function actionGetInfoReserveByPlaza($idPlaza)
    {
        $reserve = Reserva::find()
            ->select(['reserva.*', 'cliente.nombre_completo', 'cliente.email', 'cliente.placa', 'cliente.ci', 'plaza.numero', 'tarifa.nombre', 'tarifa.costo', 'cliente.cargo', 'cliente.unidad', 'cliente.telefono'])
            ->innerJoin('cliente', 'cliente.id = reserva.cliente_id')
            ->innerJoin('plaza', 'plaza.id = reserva.plaza_id')
            ->innerJoin('tarifa', 'tarifa.id = reserva.tarifa_id')
            ->where(['plaza_id' => $idPlaza])
            ->asArray()
            ->one();
        if ($reserve) {
            $response = [
                'success' => true,
                'message' => 'Informacion de la reserva',
                'infoReserve' => $reserve
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'No tiene reserva',
                'infoReserve' => []
            ];
        }
        return $response;
    }
}
