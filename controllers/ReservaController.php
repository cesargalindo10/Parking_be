<?php

namespace app\controllers;

use app\models\Informacion;
use app\models\Plaza;
use app\models\Reserva;
use app\models\Tarifa;
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

    public function actionIndex($pageSize=5)
    {
        $query = Reserva::find()
            ->select(['reserva.*', 'cliente.nombre_completo', 'cliente.email', 'cliente.placa', 'cliente.ci'])
            ->innerJoin('cliente', 'cliente.id = reserva.cliente_id');

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
        $reserve->fecha_inicio = $information->fecha_inicio_reserva;
        $reserve->fecha_fin = $this->dateEnd($reserve['tarifa_id']);
        $imgVoucher = UploadedFile::getInstanceByName('img');

        if ($imgVoucher) {
            $fileName = uniqid() . '.' . $imgVoucher->getExtension();
            $imgVoucher->saveAs(Yii::getAlias('@app/web/upload/' . $fileName));
            $reserve->comprobante = $fileName;
        }

        if ($reserve->save()) {
            $plaza = Plaza::findOne($data['plaza_id']);
            $plaza->estado = 'ocupado';
            if ($plaza->save()) {
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

    private function dateEnd($idTarifa)
    {/* calcular  */
        return '2023-12-31';
    }

    public function actionGetCustomerReserve($idCustomer)
    {
        $reserve = Reserva::find()
            ->where(['cliente_id' => $idCustomer, 'estado' => true])
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
}
