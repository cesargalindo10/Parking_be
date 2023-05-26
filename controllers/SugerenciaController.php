<?php

namespace app\controllers;

use app\models\Cliente;
use app\models\Sugerencia;
use Yii;
use yii\data\Pagination;

class SugerenciaController extends \yii\web\Controller
{
    public function behaviors(){
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'index'=>['GET'],
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

    public function actionIndex ($pageSize=5){
        $query = Sugerencia::find()
                            ->select(['sugerencia.*', 'cliente.nombre_completo', 'cliente.email', 'cliente.placa'])
                            ->innerJoin('cliente', 'cliente.id = sugerencia.cliente_id');

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $claims = $query
                        ->orderBy('id DESC')
                        ->offset($pagination->offset)
                        ->limit($pagination->limit)
                        ->asArray()        
                        ->all();
        
        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
        'success' => true,
        'message' => 'lista de Sugerencias',
        'pageInfo' => [
            'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
            'previus' => $currentPage == 1 ? null: $currentPage - 1,
            'count' => count($claims),
            'page' => $currentPage,
            'start' => $pagination->getOffset(),
            'totalPages' => $totalPages,
        ],
            'claims' => $claims
        ];
        return $response;
    }

    public function actionCreateClaim ($idCustomer){
        $customer = Cliente::findOne($idCustomer);
        $params = Yii::$app->getRequest()->getBodyParams();
        if($customer){
            $claim = new Sugerencia();
            $claim -> load($params, '');
            if($claim -> save()){
                $response = [
                    'success' => true,
                    'message' => 'Sugerencia enviada con exito.',
                    'claim' => $claim
                ];
            }else{
                 $response = [
                    'success' => false,
                    'message' => 'Existe errores en los parametros.',
                    'claim' => $claim -> errors
                ];
            }
        }else{
             $response = [
                    'success' => false,
                    'message' => 'No existe el cliente.',
                    'claim' => []
                ];
        }

        return $response;
    }
}
