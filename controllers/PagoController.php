<?php

namespace app\controllers;
use app\models\Pago;
use app\models\Plaza;
use app\models\Reserva;
use app\models\Tarifa;
use Yii;
use yii\helpers\ArrayHelper;
use yii\helpers\Json;
use yii\web\UploadedFile;

class PagoController extends \yii\web\Controller
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
    /*     $behaviors['authenticator'] = [         	
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

    public function actionPayFee($idReserve){
        $reserve = Reserva::findOne($idReserve);
        if($reserve){
            $data = Json::decode(Yii::$app->request->post('data'));
            $pay = new Pago();
            $pay -> load($data, '');
            $imgVoucher = UploadedFile::getInstanceByName('img');
            if($imgVoucher){
                $fileName = uniqid() . '.' . $imgVoucher->getExtension();
                $imgVoucher->saveAs(Yii::getAlias('@app/web/upload/' . $fileName));
                $pay->comprobante = $fileName;
            }
            if($pay -> save()){
                $response = [
                    'success' => true,
                    'message' => 'Su pago se realizo exitosamente..',
                    'reserve' => $pay
                ];
            }else{
                $response = [
                    'success' => false,
                    'message' => 'Existen errores en los parametros.',
                    'errors' => $pay->errors
                ];
            }
        }else{

        }
        return $response;
    }

    public function actionConfirmPayment($idPayment){
        $payment = Pago::findOne($idPayment);
        if($payment){
            $reserve = Reserva::findOne($payment -> reserva_id);
            $totalPaid = $this->calculatePaid($reserve -> id);
            $tarifa = Tarifa::findOne($reserve -> tarifa_id);
            $plaza = Plaza::findOne($reserve -> plaza_id);
            $plaza -> estado = 'asignado';
            if($totalPaid >= $tarifa -> costo){
                $reserve -> estado = 'pagado';  
            }
            $payment -> estado = true; 
            $payment -> estado_plaza = 'aprobado'; 
            if($payment -> save() && $reserve -> save() && $plaza -> save()){
                $response = [
                    'success' => true,
                    'message' => 'Se confirmo el pago.',
                    'reserve' => $payment 
                ];
            }else{
                 $response = [
                    'success' => false,
                    'message' => 'Existen errores en los parametros.',
                    'errors' => $payment->errors,
                    'errors2' => $reserve->errors
                ];
            }
        }else{

        }
        return $response;
    }
    public function calculatePaid($idReserve){
        $payments = Pago::find()->where(['reserva_id' => $idReserve])->all();
        $totalPaid = 0;
        foreach ($payments as $key => $value) {
            $totalPaid +=  $value -> total;
        }
        
        return $totalPaid;
    }

    public function actionGetPaymentsByDay(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $fechaFinWhole = $params['fechaFin'] . ' ' . '23:59:00.000';
        $payments = Pago::find()
                    ->select(['sum(total) as total', 'Date(fecha) As fecha'])
                    ->where(['between', 'fecha', $params['fechaInicio'], $fechaFinWhole])
                    ->groupBy('Date(fecha)')
                    ->all();
        if($payments){
            $response = [
                'success' => true,
                'message' => 'Reportes por dia',
                'payments' => $payments
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existen reportes',
                'payments' => []
            ];
        }
        return $response;
    }  

    public function actionCancelPayment ($idPayment){
        $payment = Pago::findOne($idPayment);
        if($payment){
            $payment -> estado_plaza = 'cancelado';
            $payment -> estado = false;
            if($payment -> save()){
                $response = [
                    'success' => true,
                    'message' => 'Se actualizo exitosamente',
                    'payments' => $payment
                ];
            }else{
                $response = [
                    'success' => false,
                    'message' => 'Existen errores',
                    'errors' => $payment->errors
                ];
            }
        }else{
            $response = [
                'success' => false,
                'message' => 'No existe pago',
                'payment' => []
            ];
        }
        return $response;
    }
}
