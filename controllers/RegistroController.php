<?php

namespace app\controllers;

use app\models\Cliente;
use app\models\Parqueo;
use app\models\Plaza;
use app\models\Registro;
use app\models\Reserva;
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
       /* Si ya registro entrda, SOLO llenar fecha_salida, si no tiene registro entrada, recien crear registro */
       $params = Yii::$app->getRequest()->getBodyParams();
       $record = Registro::find()->where(['cliente_id' => $params['cliente_id'], 'fecha_salida' => null])->one(); 
       if($record){
         /* Actualizar fecha de salida */
         date_default_timezone_set('America/La_Paz');
         $record -> fecha_salida = date('Y-m-d H:i:s');
         if($record -> save()){
            $response = [
                'success' => true,
                'message' => 'Se actualizo correctamente.',
                'register' => $record
            ];
         }else{
            $response = [
                'success' => false,
                'message' => 'Existen errores en los parametros.',
                'errors' => $record-> errors
            ];
         }
       } else{
        /* Crear nuevo registro */
        $register = new Registro();
        $register->usuario_id = $params['usuario_id'];
        $register->cliente_id = $params['cliente_id'];
        $register->fecha_salida = null;

        if ($register->save()) {
            $response = [
                'success' => true,
                'message' => 'Se registro correctamente.',
                'register' => $register
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'Existe erros en los parametros.',
                'register' => $register->errors
            ];
        }
        }
        return $response;
    }
  /*   public function actionGetClient($placa)
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
    } */
    public function actionIndex()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        return  Registro::find()->where(['cliente_id' => $params['cliente_id'], 'fecha_salida' => null])->all();
    }

    public function actionGetRecords(){
        $records = Registro::find()
                            ->select(['registro.*', 'cliente.nombre_completo as cliente', 'cliente.placa'])
                            ->innerJoin('cliente', 'cliente.id=registro.cliente_id')
                            ->orderBy(['id' => SORT_DESC])
                            ->asArray()
                            ->all();
        if($records){
            $response = [
                'success' => true, 
                'message' => 'Lista de registros',
                'records' => $records
            ];
        }else{
            $response = [
                'success' => false, 
                'message' => 'No existen registros',
                'records' => $records
            ];
        }

        return $response;
    }

    public function actionGetClient($placa){
        $customer = Cliente::find()->where(['placa' => $placa])->one();
        $record = Registro::find()->where(['cliente_id' => $customer->id, 'fecha_salida' => null])->one();
        $reserva = Reserva::find()->where(['cliente_id' => $customer->id, 'finalizado' => false])->one();
        $parqueo = [];
        if($reserva){
            $plaza = Plaza::findOne($reserva->plaza_id);
            $parqueo = Parqueo::findOne($plaza -> parqueo_id);
        }
        if($customer){
            $response = [
                'success' => true, 
                'message' => 'Lista de registros',
                'customer' => $customer,
                'record' => $record,
                'parqueo' => $parqueo
            ];
        }else{
            $response = [
                'success' => false, 
                'message' => 'No existen registros',
                'record' => [],
                'parqueo' => []
            ];
        }
        return $response;
    }

    public function actionGetRecordsByDate(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $fechaFinWhole = $params['fechaFin'] . ' ' . '23:59:00.000';
        $records = Registro::find()
        ->select(['registro.*', 'cliente.nombre_completo as cliente', 'cliente.placa'])
        ->innerJoin('cliente', 'cliente.id=registro.cliente_id')
        ->where(['between', 'fecha_ingreso', $params['fechaInicio'], $fechaFinWhole])
        ->orderBy(['id' => SORT_DESC])
        ->asArray()
        ->all();

        if($records){
            $response = [
                'success' => true, 
                'message' => 'Lista de registros',
                'records' => $records
            ];
        }else{
            $response = [
                'success' => false, 
                'message' => 'No existen registros',
                'records' => []
            ];
        }
        return $response;
    }
}
