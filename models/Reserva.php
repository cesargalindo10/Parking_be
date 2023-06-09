<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "reserva".
 *
 * @property int $id
 * @property string $estado
 * @property string $fecha_inicio
 * @property string $fecha_fin
 * @property int $cliente_id
 * @property int $plaza_id
 * @property int $tarifa_id
 * @property int|null $cantidad
 * @property bool|null $couta
 * @property bool $finalizado
 *
 * @property Cliente $cliente
 * @property Pago[] $pagos
 * @property Plaza $plaza
 * @property Tarifa $tarifa
 */
class Reserva extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'reserva';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['fecha_inicio', 'fecha_fin'], 'safe'],
            [['fecha_fin', 'cliente_id', 'plaza_id', 'tarifa_id'], 'required'],
            [['cliente_id', 'plaza_id', 'tarifa_id', 'cantidad'], 'default', 'value' => null],
            [['cliente_id', 'plaza_id', 'tarifa_id', 'cantidad'], 'integer'],
            [['couta', 'finalizado'], 'boolean'],
            [['estado'], 'string', 'max' => 25],
            [['cliente_id'], 'exist', 'skipOnError' => true, 'targetClass' => Cliente::class, 'targetAttribute' => ['cliente_id' => 'id']],
            [['plaza_id'], 'exist', 'skipOnError' => true, 'targetClass' => Plaza::class, 'targetAttribute' => ['plaza_id' => 'id']],
            [['tarifa_id'], 'exist', 'skipOnError' => true, 'targetClass' => Tarifa::class, 'targetAttribute' => ['tarifa_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'estado' => 'Estado',
            'fecha_inicio' => 'Fecha Inicio',
            'fecha_fin' => 'Fecha Fin',
            'cliente_id' => 'Cliente ID',
            'plaza_id' => 'Plaza ID',
            'tarifa_id' => 'Tarifa ID',
            'cantidad' => 'Cantidad',
            'couta' => 'Couta',
            'finalizado' => 'Finalizado',
        ];
    }

    /**
     * Gets query for [[Cliente]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getCliente()
    {
        return $this->hasOne(Cliente::class, ['id' => 'cliente_id']);
    }

    /**
     * Gets query for [[Pagos]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getPagos()
    {
        return $this->hasMany(Pago::class, ['reserva_id' => 'id']);
    }

    /**
     * Gets query for [[Plaza]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getPlaza()
    {
        return $this->hasOne(Plaza::class, ['id' => 'plaza_id']);
    }

    /**
     * Gets query for [[Tarifa]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getTarifa()
    {
        return $this->hasOne(Tarifa::class, ['id' => 'tarifa_id']);
    }
}
