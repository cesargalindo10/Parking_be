<?php

namespace app\controllers;

use app\models\Parqueo;
use app\models\Plaza;
use Exception;
use Yii;
use yii\data\Pagination;
use yii\db\IntegrityException;

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
    public function actionIndex($pageSize = 5){
        $query = Parqueo::find()->with('plazas');

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $parkins = $query
                        ->orderBy('id DESC')
                        ->offset($pagination->offset)
                        ->limit($pagination->limit)        
                        ->asArray()
                        ->all();
        
        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
        'success' => true,
        'message' => 'lista de parkins',
        'pageInfo' => [
            'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
            'previus' => $currentPage == 1 ? null: $currentPage - 1,
            'count' => count($parkins),
            'page' => $currentPage,
            'start' => $pagination->getOffset(),
            'totalPages' => $totalPages,
            'parkins' => $parkins
            ]
        ];
        return $response;

    }
    public function actionCreate(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $fila = (int)$params['nro_filas'];
        $colum = (int)$params['nro_columnas'];
        $nombre = (string)$params['nombre'];
        $parking = new Parqueo();
        $parking->load($params, "");
        $equal = Parqueo::find()->where(['nombre' => $nombre])->one();
        if($equal){
            return [
                'success'=>false,
                'message'=>'Error, ya existe ese nombre',
            ];
        }

        try{
            if($parking->save()){
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success'=>true,
                    'message'=> 'Parqueo se creo con Exito',
                    'data'=>$parking,
                
                ];
                //$park=Parqueo::find()->where(['nombre'=>$nombre])->one();
                
                $this->createPlaza($fila * $colum, $parking->id );
            }else{
                Yii::$app->getResponse()->getStatusCode(222,'La validacion de datos a fallado');
                $response=[
                    'success'=>false,
                    'message'=>'fallo al crear parqueo',
                    'data'=>$parking->errors
                ];
            }
        }catch(Exception $e){

            Yii::$app->getResponse()->getStatusCode(500);
            $response = [
                'success'=>false,
                'message'=>'ocurrio un error al crear parqueo',
                'data'=>$e->getMessage()
            ];
        }
        return $response;
        

    }

    public function actionUpdate($id)
    {
     
        $params = Yii::$app->getRequest()->getBodyParams();
        $fila = (int)$params['nro_filas'];
        $colum = (int)$params['nro_columnas'];
        $nombre = (string)$params['nombre'];
        $parking = Parqueo::findOne($id);
        if ($parking) {
            $parking->load($params, '');
            try{
                if ($parking->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el parqueo de manera correcta',
                        'data' => $parking
                    ];
                    $reg = Plaza::find()->where(['parqueo_id'=>$id])->all();
                    foreach ($reg as $re) {
                        $re->delete();
                    }
                    $park=Parqueo::find()->where(['nombre'=>$nombre])->one();
                    $this->createPlaza($fila * $colum, $park->id );
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar parqueo',
                        'data' => $parking->errors
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
                'message' => 'parqueo no encontrado',
                
            ];
        }

        return $response;
    }
    public function actionDelete($id){
        
        $parking = Parqueo::findOne($id);
        if($parking){
            try{
                $parking->delete();
                $response = [
                    'success' => true,
                    'message' => 'Parqueo eliminado '
                ];

            }catch(IntegrityException $ie){
                Yii::$app->getResponse()->setStatusCode(409);
                $response = [
                    'success' => false,
                    'message' =>'El parqueo esta siendo usado',
                    'code' => $ie->getCode() 
                ];

            }catch(Exception $e){
                    Yii::$app->getResponse()->setStatusCode(422,'La validacion de datos a fallado');
                    $response = [
                        'success' => false,
                        'message'=>$e->getMessage(),
                        'code' => $e->getCode()
                    ];
            }

        }else{
            Yii::$app->getResponse()->getStatusCode(404);
            $response = [
                'success' => false,
                'message' => 'usuario no encontrado',
                
            ];
        }
        return $response;
    }
    public function createPlaza($n, $id)
    {
        for($i=0;$i<$n;$i++){
            $plaza = new Plaza();
            $plaza->estado="camino";
            $plaza->numero=$i."";
            $plaza->parqueo_id=$id;
            $plaza->habilitado=false;

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
        }

        return $response;
    }

    public function actionGetInfoParking($idParking){
        $parking = Parqueo::findOne($idParking);
        if($parking){
            $places = Plaza::find()
                        ->where(['parqueo_id' => $idParking])
                        ->orderBy(['id' => SORT_ASC])
                        ->all();
            $response = [
                'success' => true,
                'message' => 'Informacion de parqueo',
                'parking' => $parking,
                'places' => $places
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existe parqueo',
                'parking' => [],
                'places' => []
            ];
        }
        return $response;
    }

    public function actionGetParkings(){
        $parkings = Parqueo::find()->all();
        if($parkings){
            $response = [
                'success' => true,
                'message' => 'Lista de parqueo',
                'parkings' => $parkings
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existe parqueo',
                'parkings' => []
            ];
        }
        return $response;
    }

}
