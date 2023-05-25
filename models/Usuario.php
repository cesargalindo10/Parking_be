<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "usuario".
 *
 * @property int $id
 * @property string $nombre
 * @property string $email
 * @property string $rol
 * @property string $password_hash
 * @property string $access_token
 *
 * @property TurnoUsuario[] $turnoUsuarios
 */
class Usuario extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'usuario';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nombre', 'email', 'rol', 'password_hash', 'access_token'], 'required'],
            [['password_hash', 'access_token'], 'string'],
            [['nombre', 'email'], 'string', 'max' => 50],
            [['rol'], 'string', 'max' => 20],
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
            'email' => 'Email',
            'rol' => 'Rol',
            'password_hash' => 'Password Hash',
            'access_token' => 'Access Token',
        ];
    }

    /**
     * Gets query for [[TurnoUsuarios]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getTurnoUsuarios()
    {
        return $this->hasMany(TurnoUsuario::class, ['usuario_id' => 'id']);
    }
    public function getTurno(){
        return $this->hasMany(Turno::class,['id'=>'turno_id'])
        ->viaTable('turno_usuario', ['usuario_id' => 'id']);
    }
}
