<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "tarifa".
 *
 * @property int $id
 * @property string $nombre
 * @property int $costo
 * @property bool $estado
 *
 * @property Reserva[] $reservas
 */
class Tarifa extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'tarifa';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nombre', 'costo'], 'required'],
            [['costo'], 'default', 'value' => null],
            [['costo'], 'integer'],
            [['estado'], 'boolean'],
            [['nombre'], 'string', 'max' => 10],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'nombre' => 'Nombre',
            'costo' => 'Costo',
            'estado' => 'Estado',
        ];
    }

    /**
     * Gets query for [[Reservas]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getReservas()
    {
        return $this->hasMany(Reserva::class, ['tarifa_id' => 'id']);
    }
}
