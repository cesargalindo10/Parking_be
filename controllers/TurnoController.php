<?php

namespace app\controllers;

use app\models\Turno;
use Exception;
use Yii;

class TurnoController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create-turn' => ['POST'],
                'update' => ['POST']

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
    public function actionGetTurn()
    {
        $turns = Turno::find()->all();
        return $turns;
    }
    public function actionCreateTurn()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $turn = new Turno();
        $turn->load($params, "");
        try{
            if($turn->save()){
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success'=>true,
                    'message'=> 'Turno se creo con Exito',
                    'data'=>$turn
                ];
            }else{
                Yii::$app->getResponse()->getStatusCode(222,'La validacion de datos a fallado');
                $response=[
                    'success'=>false,
                    'message'=>'fallo al crear turno',
                    'data'=>$turn->errors
                ];
            }
        }catch(Exception $e){

            Yii::$app->getResponse()->getStatusCode(500);
            $response = [
                'success'=>false,
                'message'=>'ocurrio un error al crear turno',
                'data'=>$e->getMessage()
            ];
        }
        return $response;
    }
    public function actionIndex()
    {
        return $this->render('index');
    }

    public function actionGetTurnos(){
        $turnos = Turno::find()
                        ->orderBy(['id' => SORT_DESC])    
                        ->all();
        return [
            'success' => true,
            'message' => 'Lista de turnos',
            'turnos' => $turnos
        ];
    }

    public function actionUpdate($id){
        $turno = Turno::findOne($id);
        $params = Yii::$app->getRequest()->getBodyParams();
        $turno -> load($params, '');
        if($turno -> save()){
            $response = [
                'success'=>true,
                'message'=> 'Turno se actualizo con Exito',
                'turno'=>$turno
            ];
        }else{
            $response = [
                'success'=>false,
                'message'=> 'Ocurrio un error',
                'turno'=>$turno
            ];
        }
        return $response;
    }

    public function actionDeleteTurno($id){
        $turno = Turno::findOne($id);
        $turno -> estado = 0;
        if($turno -> save()){
            $response = [
                'success'=>true,
                'message'=> 'Turno se actualizo con Exito',
                'turno'=>$turno
            ];
        }else{
            $response = [
                'success'=>false,
                'message'=> 'Ocurrio un error',
                'turno'=>$turno
            ];
        }
        return $response;
    }
}
