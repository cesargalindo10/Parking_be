<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "convocatoria".
 *
 * @property string $convocatoria
 * @property string $fecha_inicio_pago
 * @property string $fecha_limite_reserva
 * @property string $fecha_inicio_reserva
 * @property string $fecha_fin_reserva
 * @property int $id
 */
class Convocatoria extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'convocatoria';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['convocatoria', 'fecha_inicio_pago', 'fecha_limite_reserva', 'fecha_inicio_reserva', 'fecha_fin_reserva'], 'required'],
            [['fecha_inicio_pago', 'fecha_limite_reserva', 'fecha_inicio_reserva', 'fecha_fin_reserva'], 'safe'],
            [['convocatoria'], 'string', 'max' => 50],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'convocatoria' => 'Convocatoria',
            'fecha_inicio_pago' => 'Fecha Inicio Pago',
            'fecha_limite_reserva' => 'Fecha Limite Reserva',
            'fecha_inicio_reserva' => 'Fecha Inicio Reserva',
            'fecha_fin_reserva' => 'Fecha Fin Reserva',
            'id' => 'ID',
        ];
    }
}
