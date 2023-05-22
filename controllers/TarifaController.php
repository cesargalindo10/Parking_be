<?php

namespace app\controllers;
use Yii;
use app\models\Tarifa;
use yii\data\Pagination;

class TarifaController extends \yii\web\Controller
{
   
   
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors["verbs"] = [
            "class" => \yii\filters\VerbFilter::class,
            "actions" => [
                'index' => ['get'],
                'create' => ['post'],
                'update' => ['put', 'post'],
                'delete' => ['delete'],
                'get-category' => ['get'],

            ]
        ];
/*         $behaviors['authenticator'] = [         	
            'class' => \yii\filters\auth\HttpBearerAuth::class,         	
            'except' => ['options']     	
        ]; */
        return $behaviors;
    }

    public function actionIndex ($pageSize=5){
        $query = Tarifa::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $payments = $query
            ->orderBy('id DESC')
            ->offset($pagination->offset)
            ->limit($pagination->limit)
            ->all();

        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
            'success' => true,
            'message' => 'lista de pagos',
            'pageInfo' => [
                'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
                'previus' => $currentPage == 1 ? null : $currentPage - 1,
                'count' => count($payments),
                'page' => $currentPage,
                'start' => $pagination->getOffset(),
                'totalPages' => $totalPages,
            ],
            'payments' => $payments
        ];
        return $response;
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

    public function actionCreate (){
        $params = Yii::$app->getRequest()->getBodyParams();

        $pay = new Tarifa();
        $pay -> load($params, '');
        if($pay -> save()){
            $response = [
                'success' => true,
                'message' => 'Se creo correctamente.',
                'pay' => $pay
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'Existe erros en los parametros.',
                'pay' => $pay->errors
            ];
        }     

        return $response;
    }

    public function actionUpdate ($id){
        $params = Yii::$app->getRequest()->getBodyParams();

        $pay = Tarifa::findOne($id);
        $pay -> load($params, '');
        if($pay -> save()){
            $response = [
                'success' => true,
                'message' => 'Se actualizo correctamente.',
                'pay' => $pay
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'Existe erros en los parametros.',
                'pay' => $pay
            ];
        }     
        return $response;
    }

    public function actionDisablePay($idPay){
        $pay = Tarifa::findOne($idPay);   
        if($pay){
            $pay -> estado = false;
            if($pay -> save()){
                $response = [
                    'success' => true,
                    'message' => 'Se actualizo correctamente.',
                    'pay' => $pay
                ];
            }else{
                $response = [
                    'success' => false,
                    'message' => 'Existe erros en los parametros.',
                    'pay' => $pay->errors
                ];
            } 
        }else{
            $response = [
                'success' => false,
                'message' => 'No se encontro el Tarifa.',
                'pay' => $pay
            ];
        }
        return $response;
    }
}
