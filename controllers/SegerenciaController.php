<?php

namespace app\controllers;

use app\models\Sugerencia;
use Yii;
use yii\data\Pagination;

class SegerenciaController extends \yii\web\Controller
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
        $query = Sugerencia::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $claims = $query
                        ->orderBy('id DESC')
                        ->offset($pagination->offset)
                        ->limit($pagination->limit)        
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
}
