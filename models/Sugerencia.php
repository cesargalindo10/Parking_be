<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "sugerencia".
 *
 * @property int $id
 * @property int $cliente_id
 * @property string $mensaje
 *
 * @property Cliente $cliente
 */
class Sugerencia extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'sugerencia';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['cliente_id', 'mensaje'], 'required'],
            [['cliente_id'], 'default', 'value' => null],
            [['cliente_id'], 'integer'],
            [['mensaje'], 'string'],
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
            'cliente_id' => 'Cliente ID',
            'mensaje' => 'Mensaje',
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
