<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "pago".
 *
 * @property int $id
 * @property string|null $fecha
 * @property int $nro_cuotas_pagadas
 * @property int $reserva_id
 *
 * @property Reserva $reserva
 */
class Pago extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'pago';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['fecha'], 'safe'],
            [['nro_cuotas_pagadas', 'reserva_id'], 'required'],
            [['nro_cuotas_pagadas', 'reserva_id'], 'default', 'value' => null],
            [['nro_cuotas_pagadas', 'reserva_id'], 'integer'],
            [['reserva_id'], 'exist', 'skipOnError' => true, 'targetClass' => Reserva::class, 'targetAttribute' => ['reserva_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'fecha' => 'Fecha',
            'nro_cuotas_pagadas' => 'Nro Cuotas Pagadas',
            'reserva_id' => 'Reserva ID',
        ];
    }

    /**
     * Gets query for [[Reserva]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getReserva()
    {
        return $this->hasOne(Reserva::class, ['id' => 'reserva_id']);
    }
}
