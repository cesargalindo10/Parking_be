<?php

namespace app\controllers;

use app\models\Turno;
use app\models\TurnoUsuario;
use app\models\Usuario;
use Exception;
use Yii;
use yii\data\Pagination;

class TurnoUsuarioController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'get-turn' => ['GET'],
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
    public function actionGetUser()
    {
        $users = Usuario::find()->all();
        $aux = array();
        for ($i = 0; $i < sizeof($users); $i++) {
            $id = $users[$i]->id;
            $turn = TurnoUsuario::find()->where(['usuario_id' => $id])->all();           

            if ($turn) {
                $turn_n = Turno::findOne($turn[0]->turno_id);
                $usuario = [
                    'user' => $users[$i],
                    'turn_nombre' => $turn_n->nombre
                ];
            } else {
                $usuario = [
                    'user' => $users[$i],
                    'turn_id' => '',
                ];
            }
            array_push($aux, $usuario);
        }
        return $aux;
    }
    public function actionAssignTurn($user_id, $turn_id)
    {

        if ($this->verificar($user_id)) {
            $this->delete($user_id);
            $this->asignarTurn($user_id, $turn_id);
        } else {
            $this->asignarTurn($user_id, $turn_id);
        }
    }

    public function delete($user_id)
    {
        $turno_usuario = TurnoUsuario::find()->where(['usuario_id' => $user_id])->all();
        $turno_usuario_by_id = TurnoUsuario::findOne($turno_usuario[0]->id);
        if ($turno_usuario  && $turno_usuario_by_id) {

            try {
                $turno_usuario_by_id->delete();
                $resultado = [
                    'success' => true,
                    'message' => 'TurnoUsuario eliminado '
                ];
            } catch (Exception $e) {
                Yii::$app->getResponse()->setStatusCode(422, 'Data validation failed');
                $resultado = [
                    'success' => false,
                    'message' => $e->getMessage(),
                    'code' => $e->getCode()
                ];
            }
        }
        return $resultado;
    }
    /**Verifica si un usuario se encuentra en la tabla turnousuario */
    public function verificar($user_id)
    {
        $response = TurnoUsuario::find()->where(['usuario_id' => $user_id])->all();
        if ($response) {
            return true;
        } else {
            return false;
        }
    }
    /**
     * Enlaza usuario_id con turno_id y crea un registro en la tabla turno_usuario
     */
    public function asignarTurn($user_id, $turn_id)
    {

        $user = Usuario::findOne($user_id);
        if ($user) {

            $turn = Turno::findOne($turn_id);
            if ($turn) {

                if (!$user->getTurno()->where("id={$turn_id}")->one()) {

                    try {
                        $user->link('turno', $turn);
                        $resultado = [
                            'success' => true,
                            'message' => 'Se asigno el turno al usuario correctamente.'
                        ];
                    } catch (Exception $e) {

                        Yii::$app->getResponse()->setStatusCode(500);
                        $resultado = [
                            'message' => $e->getMessage(),
                            'code' => $e->getCode(),
                        ];
                    }
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'Existing link.');
                    $resultado = [
                        'success' => false,
                        'message' => 'La materia ya posee periodo'
                    ];
                }
            } else {
                throw new \yii\web\NotFoundHttpException('periodo no encontrado.');
            }
        } else {
            throw new \yii\web\NotFoundHttpException('Materia no encontrada.');
        }
        return $resultado;
    }

    public function actionIndex($pageSize = 5){
        //$query = Usuario::find();
        $users = Usuario::find()->all();
        $aux = array();
        for ($i = 0; $i < sizeof($users); $i++) {
            $id = $users[$i]->id;
            $turn = TurnoUsuario::find()->where(['usuario_id' => $id])->all();

            if ($turn) {
                $turn_id = $turn[0]->turno_id;
                $usuario = [
                    'user' => $users[$i],
                    'turn_id' => $turn_id
                ];
            } else {
                $usuario = [
                    'user' => $users[$i],
                    'turn_id' => '',
                ];
            }
            array_push($aux, $usuario);
        }
        $query = (object)$aux;
        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => sizeof($aux),
        ]);

        $users = $query
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
    public function actionTest(){
        $turn = TurnoUsuario::find()->where(['usuario_id' => 6])->all();
        //$turn_n = Turno::findOne($turn['turno_id']);
        return $turn[0]->turno_id;
    }

    public function actionGetTurnoPorUsuario(){
        $userWithTurnos = Usuario::find()
                            ->with('turno')
                            ->asArray()
                            ->all();
        if($userWithTurnos){
            $response = [
                'success' => true,
                'message' => 'Lista de usuarios',
                'userWithTurnos' => $userWithTurnos
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'NO existen usuarios',
                'userWithTurnos' => []
            ];
        }
        return $response;
    }
}
