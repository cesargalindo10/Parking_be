<?php

namespace app\controllers;

use app\models\Cliente;
use app\models\Registro;
use Symfony\Component\BrowserKit\Client;
use Yii;

class RegistroController extends \yii\web\Controller
{
    public function behaviors(){
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create'=>['POST'],
                'get-client'=>['get']

            ]
         ];
      /*$behaviors['authenticator'] = [
            'class' => \yii\filters\auth\HttpBearerAuth::class,
            'except' => ['options','login','create-client']
        ];*/
        return $behaviors;
    }

    public function beforeAction( $action ) {
        if (Yii::$app->getRequest()->getMethod() === 'OPTIONS') {         	
            Yii::$app->getResponse()->getHeaders()->set('Allow', 'POST GET PUT');         	
            Yii::$app->end();     	    
        }     
        $this->enableCsrfValidation = false;
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        return parent::beforeAction($action);
    }
    public function actionCreate()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $register = new Registro();
        $register->load($params, '');
        if ($register->save()) {
            $response = [
                'success' => true,
                'message' => 'Se creo correctamente.',
                'register' => $register
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'Existe erros en los parametros.',
                'register' => $register->errors
            ];
        }

        return $response;
    }
    public function actionGetClient($placa)
    {
        $client = Cliente::find()->where(["placa" => $placa])->one();
        if ($client) {
            $register = Registro::find()->where(["cliente_id" => $client->id])->one();
      
            if($register){
                $re=Registro::find()
                ->Where(["fecha_ingreso" => $register->fecha_ingreso])
                ->orWhere(["fecha_salida" => $register->fecha_salida])
                ->one();
                if($re){
                    $response=[
                        "success"=>true,
                        "client"=> $client,
                        "register"=>$re
                    ];
                }else{
                    $response=[
                        "success"=>true,
                        "client"=> $client,
                        "register"=>""
                    ];
                }
                
         
            }else{
                $response=[
                    "success"=>true,
                    "client"=> $client,
                    "register"=>""
                ];
            }
        }else{
            $response=[
                "success"=>false,
                "message"=>"cliente no registrado"      
            ];
        }
        return $response;
    }
    public function actionIndex()
    {
        return   Registro::find()->where(["cliente_id" => 2])->one();;
    }
}
