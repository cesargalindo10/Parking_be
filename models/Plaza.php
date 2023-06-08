<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "plaza".
 *
 * @property int $id
 * @property string $estado
 * @property string $numero
 * @property int $parqueo_id
 * @property bool|null $habilitado
 *
 * @property Parqueo $parqueo
 * @property Reserva[] $reservas
 */
class Plaza extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'plaza';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['estado', 'numero', 'parqueo_id'], 'required'],
            [['parqueo_id'], 'default', 'value' => null],
            [['parqueo_id'], 'integer'],
            [['habilitado'], 'boolean'],
            [['estado'], 'string', 'max' => 20],
            [['numero'], 'string', 'max' => 10],
            [['parqueo_id'], 'exist', 'skipOnError' => true, 'targetClass' => Parqueo::class, 'targetAttribute' => ['parqueo_id' => 'id']],
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
            'numero' => 'Numero',
            'parqueo_id' => 'Parqueo ID',
            'habilitado' => 'Habilitado',
        ];
    }

    /**
     * Gets query for [[Parqueo]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getParqueo()
    {
        return $this->hasOne(Parqueo::class, ['id' => 'parqueo_id']);
    }

    /**
     * Gets query for [[Reservas]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getReservas()
    {
        return $this->hasMany(Reserva::class, ['plaza_id' => 'id']);
    }
}
