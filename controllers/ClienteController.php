<?php

namespace app\controllers;

use app\models\Cliente;
use Exception;
use Yii;
use yii\data\Pagination;

class ClienteController extends \yii\web\Controller
{
    public function behaviors(){
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'disable-client'=>['GET'],
                'create-client'=>['POST'],
                'update-cliente'=>['POST']

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
    public function actionCreateClient(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = new Cliente();
        $user->password_hash = Yii::$app->getSecurity()->generatePasswordHash($params["password"]);
        $user->access_token = Yii::$app->security->generateRandomString();
        $user->rol="cliente";
        $user->load($params, "");
        try{
            if($user->save()){
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success'=>true,
                    'message'=> 'Cliente se creo con Exito',
                    'data'=>$user
                ];
            }else{
                Yii::$app->getResponse()->getStatusCode(222,'La validacion de datos a fallado');
                $response=[
                    'success'=>false,
                    'message'=>'fallo al crear cliente',
                    'data'=>$user->errors
                ];
            }
        }catch(Exception $e){

            Yii::$app->getResponse()->getStatusCode(500);
            $response = [
                'success'=>false,
                'message'=>'ocurrio un error al crear cliente',
                'data'=>$e->getMessage()
            ];
        }
        return $response;
        

    }
    public function actionUpdateCustomer($id)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $customer = Cliente::findOne($id);
        if ($customer) {
            $customer->load($params, '');
            try{
                if ($customer->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el usuario de manera correcta',
                        'data' => $customer
                    ];
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar usuario',
                        'data' => $customer->errors
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
    public function actionDisableClient($id){
        $cliente = Cliente::findOne($id); 
        if($cliente){
            
                $cliente->estado=!$cliente->estado;
                try{
                if($cliente->save()){
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el cliente de manera correcta',
                        'data' => $cliente
                    ];
                }
                else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar cliente',
                        'data' => $cliente->errors
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
            $response = [
                'success' => false,
                'message' => 'Cliente no encontrado',
                
            ];
        }
        return $response;

    }

    public function actionIndex($pageSize = 5){
        $query = Cliente::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $customers = $query
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
            'count' => count($customers),
            'page' => $currentPage,
            'start' => $pagination->getOffset(),
            'totalPages' => $totalPages,
            'customers' => $customers
            ]
        ];
        return $response;

    }

}
