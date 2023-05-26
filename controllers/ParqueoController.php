<?php

namespace app\controllers;

use app\models\Parqueo;
use Exception;
use Yii;

class ParqueoController extends \yii\web\Controller
{
    public function behaviors(){
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create'=>['POST'],
                'update'=>['POST']

            ]
         ];
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

    public function actionCreate(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = new Parqueo();
        $user->password_hash = Yii::$app->getSecurity()->generatePasswordHash($params["password"]);
        $user->access_token = Yii::$app->security->generateRandomString();
        $user->load($params, "");
        try{
            if($user->save()){
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success'=>true,
                    'message'=> 'Usuarion se creo con Exito',
                    'data'=>$user
                ];
            }else{
                Yii::$app->getResponse()->getStatusCode(222,'La validacion de datos a fallado');
                $response=[
                    'success'=>false,
                    'message'=>'fallo al crear usuario',
                    'data'=>$user->errors
                ];
            }
        }catch(Exception $e){

            Yii::$app->getResponse()->getStatusCode(500);
            $response = [
                'success'=>false,
                'message'=>'ocurrio un error al crear usuario',
                'data'=>$e->getMessage()
            ];
        }
        return $response;
        

    }
    public function actionIndex()
    {
        return $this->render('index');
    }

}
