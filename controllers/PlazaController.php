<?php

namespace app\controllers;

use app\models\Plaza;
use app\models\Reserva;
use Exception;
use Yii;;
class PlazaController extends \yii\web\Controller
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
       /*  $behaviors['authenticator'] = [         	
            'class' => \yii\filters\auth\HttpBearerAuth::class,         	
            'except' => ['options']     	
        ]; */
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

    public function actionIndex()
    {
        return $this->render('index');
    }

    public function actionGetPlace($placeNumber, $idParking){
        $place = Plaza::find()
                        ->select(['plaza.*', 'parqueo.nombre as nombre'])
                        ->innerJoin('parqueo', 'parqueo.id = plaza.parqueo_id')
                        ->where(['numero' => $placeNumber, 'parqueo_id' => $idParking])
                        ->asArray()
                        ->all();

        if($place){
            $response = [
                'success' => true,
                'message' => 'Plaza encontrada.',
                'placeInformation' => $place
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'Plaza no encontrada.',
                'placeInformation' => []
            ];
        }
        return $response;
    }
    public function actionGetPlaza($idParking){
        //$plazas = Plaza::find()->orderBy("id ASC")->all();
        $plazas = Plaza::find()->where(['parqueo_id'=>$idParking])->orderBy("id ASC")->all();
        if($plazas)
        {
            $response = [
                "success"=>true,
                "plazas"=>$plazas
            ];
        }else{
            $response = [
                "success"=>false,
                "message"=>"no hay plazas"
            ];
        }
        return $response;
    }
    public function actionCreatePlaza()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $plaza = new Plaza();
        $plaza->load($params, "");
        try{
            if($plaza->save()){
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success'=>true,
                    'message'=> 'plaza se creo con Exito',
                    'data'=>$plaza
                ];
            }else{
                Yii::$app->getResponse()->getStatusCode(222,'La validacion de datos a fallado');
                $response=[
                    'success'=>false,
                    'message'=>'fallo al crear plaza',
                    'data'=>$plaza->errors
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
    public function actionUpdate($id)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $plaza = Plaza::findOne($id);
        if ($plaza) {
            $plaza->load($params, '');
            try{
                if ($plaza->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo la plaza de manera correcta',
                        'data' => $plaza
                    ];
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar plaza',
                        'data' => $plaza->errors
                    ];
                }
            }catch(Exception $e){
                $response = [
                    'success' => false,
                    'message' => 'Error al actualizar',
                    'data' => $e->getMessage()
                ];
            }
            
            
        }else{
            Yii::$app->getResponse()->getStatusCode(404);
            $response = [
                'success' => false,
                'message' => 'user no encontrado',
                
            ];
        }

        return $response;
    }
    public function actionGetPlaces(){
        $places = Plaza::find() 
                        ->orderBy(['id' => SORT_ASC])
                        -> all();
        $placesUpdated = [];
        for ($i=0; $i < count($places); $i++) { 
            $place = $places[$i];
            $reserve = Reserva::find()->where(['plaza_id' => $place->id, 'finalizado' => false])->one();
            date_default_timezone_set('America/La_Paz');
            $dateCurrently = Date('Y-m-d H:i:s');
            /* if( $reserve ){
                return [
                    'fin' => $reserve['fecha_fin'],
                    'actual' => $dateCurrently
                ];
            } */
            if($reserve && $dateCurrently > $reserve["fecha_fin"] ){
                $place -> estado = 'disponible';
                $reserve['finalizado'] = true;
                if(!$place -> save() || !$reserve -> save()){
                    return [
                        'success' => false,
                        'message' => 'Ocurrio un error'
                    ];
                }
            }
            $placesUpdated[] = $place;
        }

        if($placesUpdated){
            $response = [
                'success' => true,
                'message' => 'Lista de plazas',
                'places' => $placesUpdated
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existen plazas habilitadas',
                'places' => []
            ];
        }
        return $response;
    }

}
