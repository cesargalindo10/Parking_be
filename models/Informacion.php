<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "informacion".
 *
 * @property int $id
 * @property string $qr
 * @property string|null $convocatoria
 * @property string|null $fecha_pub_conv
 * @property string|null $fecha_inicio_reserva
 * @property string|null $fecha_limite_reserva
 * @property string|null $atencion
 * @property string|null $foto
 * @property string|null $mensaje_mora
 */
class Informacion extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'informacion';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['qr'], 'required'],
            [['fecha_pub_conv', 'fecha_inicio_reserva', 'fecha_limite_reserva', 'fecha_fin_reserva'], 'safe'],
            [['qr', 'convocatoria', 'foto'], 'string', 'max' => 50],
            [['atencion'], 'string', 'max' => 100],
            [['mensaje_mora'], 'string', 'max' => 240],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'qr' => 'Qr',
            'convocatoria' => 'Convocatoria',
            'fecha_pub_conv' => 'Fecha Pub Conv',
            'fecha_inicio_reserva' => 'Fecha Inicio Reserva',
            'fecha_limite_reserva' => 'Fecha Limite Reserva',
            'atencion' => 'Atencion',
            'foto' => 'Foto',
            'mensaje_mora' => 'Mensaje Mora',
        ];
    }
}
