<?php

namespace app\controllers;
use app\models\Pago;
use Yii;
class PagoController extends \yii\web\Controller
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
        $behaviors['authenticator'] = [         	
            'class' => \yii\filters\auth\HttpBearerAuth::class,         	
            'except' => ['options']     	
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

    public function actionCreate (){
        $params = Yii::$app->getRequest()->getBodyParams();

        $pay = new Pago();
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
                'pay' => $pay
            ];
        }     

        return $response;
    }

    public function actionUpdate ($id){
        $params = Yii::$app->getRequest()->getBodyParams();

        $pay = Pago::findOne($id);
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
                'errors' => $pay->errors
            ];
        }     
        return $response;
    }

    public function actionDisablePay($idPay){
        $pay = Pago::findOne($idPay);   
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
                    'pay' => $pay
                ];
            } 
        }else{
            $response = [
                'success' => false,
                'message' => 'No se encontro el Pago.',
                'pay' => $pay
            ];
        }
    }

}
