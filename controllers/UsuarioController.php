<?php

namespace app\controllers;

use app\models\Usuario;
use Yii;
use Exception;
use yii\data\Pagination;
use yii\db\IntegrityException;

class UsuarioController extends \yii\web\Controller
{
    public function behaviors(){
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create-user'=>['POST'],
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

    public function actionCreateUser(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = new Usuario();
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
    public function actionIndex($pageSize = 5){
        $query = Usuario::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $users = $query
                        ->orderBy('id DESC')
                        ->offset($pagination->offset)
                        ->limit($pagination->limit)        
                        ->all();
        
        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
        'success' => true,
        'message' => 'lista de clientes',
        'pageInfo' => [
            'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
            'previus' => $currentPage == 1 ? null: $currentPage - 1,
            'count' => count($users),
            'page' => $currentPage,
            'start' => $pagination->getOffset(),
            'totalPages' => $totalPages,
            'users' => $users
            ]
        ];
        return $response;

    }
    public function actionUpdate($idUser)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = Usuario::findOne($idUser);
        if ($user) {
            $user->load($params, '');
            try{
                if ($user->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el usuario de manera correcta',
                        'data' => $user
                    ];
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar usuario',
                        'data' => $user->errors
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
    public function actionDelete($idUser){
        
        $user = Usuario::findOne($idUser);
        if($user){
            try{
                $user->delete();
                $response = [
                    'success' => true,
                    'message' => 'Usuario eliminado '
                ];

            }catch(IntegrityException $ie){
                Yii::$app->getResponse()->setStatusCode(409);
                $response = [
                    'success' => false,
                    'message' =>'El user esta siendo usado',
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
 
}
