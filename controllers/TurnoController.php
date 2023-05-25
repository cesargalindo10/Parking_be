<?php

namespace app\controllers;

use app\models\Turno;
use Yii;

class TurnoController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create-user' => ['POST'],
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
    public function actionIndex()
    {
        return $this->render('index');
    }

}
