<?php

namespace app\controllers;

use app\models\Plaza;
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

    public function actionGetPlace($placeNumber){
        $place = Plaza::find()
                        ->where(['numero' => $placeNumber])
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
}
