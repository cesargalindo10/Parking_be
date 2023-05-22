<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "cliente".
 *
 * @property int $id
 * @property string $nombre_completo
 * @property int $ci
 * @property string $email
 * @property string $placa
 * @property bool $estado
 *
 * @property Reserva[] $reservas
 */
class Cliente extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'cliente';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nombre_completo', 'ci', 'email', 'placa'], 'required'],
            [['ci'], 'default', 'value' => null],
            [['ci'], 'integer'],
            [['estado'], 'boolean'],
            [['nombre_completo'], 'string', 'max' => 50],
            [['email'], 'string', 'max' => 80],
            [['placa'], 'string', 'max' => 10],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'nombre_completo' => 'Nombre Completo',
            'ci' => 'Ci',
            'email' => 'Email',
            'placa' => 'Placa',
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
        return $this->hasMany(Reserva::class, ['cliente_id' => 'id']);
    }
}
