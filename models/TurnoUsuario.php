<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "turno_usuario".
 *
 * @property int $id
 * @property int $usuario_id
 * @property int $turno_id
 *
 * @property Turno $turno
 * @property Usuario $usuario
 */
class TurnoUsuario extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'turno_usuario';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['usuario_id', 'turno_id'], 'required'],
            [['usuario_id', 'turno_id'], 'default', 'value' => null],
            [['usuario_id', 'turno_id'], 'integer'],
            [['turno_id'], 'exist', 'skipOnError' => true, 'targetClass' => Turno::class, 'targetAttribute' => ['turno_id' => 'id']],
            [['usuario_id'], 'exist', 'skipOnError' => true, 'targetClass' => Usuario::class, 'targetAttribute' => ['usuario_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'usuario_id' => 'Usuario ID',
            'turno_id' => 'Turno ID',
        ];
    }

    /**
     * Gets query for [[Turno]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getTurno()
    {
        return $this->hasOne(Turno::class, ['id' => 'turno_id']);
    }

    /**
     * Gets query for [[Usuario]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getUsuario()
    {
        return $this->hasOne(Usuario::class, ['id' => 'usuario_id']);
    }
}
