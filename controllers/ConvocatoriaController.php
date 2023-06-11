<?php

namespace app\controllers;

use app\models\Convocatoria;
use app\models\Informacion;
use Yii;
use yii\helpers\Json;
use yii\web\UploadedFile;

class ConvocatoriaController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors["verbs"] = [
            "class" => \yii\filters\VerbFilter::class,
            "actions" => [

            ]
        ];
        return $behaviors;
    }


    public function actionIndex()
    {
        $information = Informacion::find()->one();
        if($information){
            $response = [
                'success' => true,
                'message' => 'Lista de informacion',
                'information' => [
                    'mensaje_mora' => $information -> mensaje_mora,
                    'atencion' => $information -> atencion,
                    'foto' => $information -> foto,
                    'convocatoria' => $information -> convocatoria,
                    'qr' => $information -> qr,
                ],
                'dates' => [
                    'fecha_pub_conv' => $information -> fecha_pub_conv,
                    'fecha_inicio_reserva' => $information -> fecha_inicio_reserva,
                    'fecha_limite_reserva' => $information -> fecha_limite_reserva,
                    'fecha_fin_reserva' => $information -> fecha_fin_reserva,
                ]
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existe informacion',
                'information' => []
            ];
        }
        return $response;
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

    public function actionUpdateConvocatoria()
    {
        $information = Informacion::find()->one();
        /* Si existe actualizar  */
        if (!$information) {
            $information = new Informacion();
        }
        $imgQr = UploadedFile::getInstanceByName('imgQr');
        if($imgQr){
            $fileName = uniqid() . '.' . $imgQr->getExtension();
            $imgQr->saveAs(Yii::getAlias('@app/web/upload/'.$fileName));
            $information -> qr = $fileName;
        }
        $imgConvocatoria = UploadedFile::getInstanceByName('imgConvocatoria');
        if($imgConvocatoria ){
            $fileName = uniqid() . '.' . $imgConvocatoria->getExtension();
            $imgConvocatoria->saveAs(Yii::getAlias('@app/web/upload/'. $fileName));
            $information -> convocatoria = $fileName;
        }

        $imgParking = UploadedFile::getInstanceByName('imgParking');
        if($imgParking){
            $fileName = uniqid() . '.' . $imgParking->getExtension();
            $imgParking->saveAs(Yii::getAlias('@app/web/upload/'. $fileName));
            $information -> foto = $fileName;
        }

        /* Data(fechaPublicacion, fechaLimitePago, mensajeMora, atencion) */
        $data = Json::decode(Yii::$app->request->post('data'));
      /*   $information -> fecha_pub_conv = $data['fecha_pub_conv'];
        $information -> fecha_inicio_reserva = $data['fecha_inicio_reserva'];
        $information -> fecha_limite_reserva = $data['fecha_limite_reserva'];
        $information -> atencion = $data['horarioAtencion']; */
        $information -> load($data, '');

        if ($information->save()) {
            $response = [
                'success' => true,
                'message' => 'Se actualizo correctamente',
                'information' => $information
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'Ocurrio un error',
                'information' => $information->errors
            ];
        }

        return $response;
    }
    public function actionCreateConvocatoria(){
        $information = new Convocatoria();
     
        $imgConvocatoria = UploadedFile::getInstanceByName('imgConvocatoria');
        if($imgConvocatoria ){
            $fileName = uniqid() . '.' . $imgConvocatoria->getExtension();
            $imgConvocatoria->saveAs(Yii::getAlias('@app/web/upload/'. $fileName));
            $information -> convocatoria = $fileName;
        }
        $data = Json::decode(Yii::$app->request->post('data'));
    
        $information -> load($data, '');

        if ($information->save()) {
            $response = [
                'success' => true,
                'message' => 'Se creo correctamente',
                'information' => $information
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'Ocurrio un error',
                'information' => $information->errors
            ];
        }

        return $response;
    }

    public function actionGetConvocatorias (){
        $convocatorias = Convocatoria::find()
                        ->orderBy(['id' => SORT_DESC])
                        ->all();    
        if($convocatorias){
            $response = [
                'success' => true,
                'message' => 'Lista de convocatorias',
                'convocatorias' => $convocatorias
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'No existen convocatorias',
                'convocatorias' => $convocatorias
            ];
        }   
        return $response;
    }

    public function actionDelete($id){
        $convocatoria = Convocatoria::findOne($id);
        if($convocatoria -> delete()){
            $convocatorias = Convocatoria::find()->all();
            $response = [
                'success' => true,
                'message' => 'Convocatoria eliminada con exito',
                'convocatorias' => $convocatorias
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'Ocurrio un error',
            ];
        }
        return $response;
    }
    public function actionGetConvocatoria(){
        $convocatoria = Convocatoria::find()->orderBy(['id' => SORT_DESC])->one();
        if($convocatoria){
            $response = [
                'success' => true,
                'message' => 'Convocatoria eliminada con exito',
                'convocatoria' => $convocatoria
            ];
        }else{
            $response = [
                'success' => false,
                'message' => 'Convocatoria eliminada con exito',
                'convocatoria' => $convocatoria
            ];
        }
        return $response;
    }
}
