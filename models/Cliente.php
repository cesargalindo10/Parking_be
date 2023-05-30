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
 * @property bool|null $estado
 * @property string $password_hash
 * @property string $access_token
 * @property int $telefono
 * @property string $cargo
 * @property string $unidad
 *
 * @property Reserva[] $reservas
 * @property Sugerencia[] $sugerencias
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
            [['nombre_completo', 'ci', 'email', 'placa', 'password_hash', 'access_token', 'telefono', 'cargo', 'unidad'], 'required'],
            [['ci', 'telefono'], 'default', 'value' => null],
            [['ci', 'telefono'], 'integer'],
            [['estado'], 'boolean'],
            [['password_hash', 'access_token'], 'string'],
            [['nombre_completo', 'cargo'], 'string', 'max' => 50],
            [['email'], 'string', 'max' => 80],
            [['placa'], 'string', 'max' => 10],
            [['unidad'], 'string', 'max' => 20],
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
            'password_hash' => 'Password Hash',
            'access_token' => 'Access Token',
            'telefono' => 'Telefono',
            'cargo' => 'Cargo',
            'unidad' => 'Unidad',
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

    /**
     * Gets query for [[Sugerencias]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getSugerencias()
    {
        return $this->hasMany(Sugerencia::class, ['cliente_id' => 'id']);
    }
}
