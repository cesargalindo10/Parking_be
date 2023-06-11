<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "notificacion".
 *
 * @property int $id
 * @property string $mensaje
 * @property int $cliente_id
 * @property string $fecha
 *
 * @property Cliente $cliente
 */
class Notificacion extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'notificacion';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['mensaje', 'cliente_id'], 'required'],
            [['mensaje'], 'string'],
            [['cliente_id'], 'default', 'value' => null],
            [['cliente_id'], 'integer'],
            [['fecha'], 'safe'],
            [['cliente_id'], 'exist', 'skipOnError' => true, 'targetClass' => Cliente::class, 'targetAttribute' => ['cliente_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'mensaje' => 'Mensaje',
            'cliente_id' => 'Cliente ID',
            'fecha' => 'Fecha',
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
}
