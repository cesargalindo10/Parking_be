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
 * @property bool $estado
 *
 * @property TurnoUsuario[] $turnoUsuarios
 */
class Usuario extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface
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
            [['estado'], 'boolean'],
            [['nombre', 'email'], 'string', 'max' => 50],
            [['rol'], 'string', 'max' => 20],
        ];
    }

    public static function findIdentity($id)
    {
        //return isset(self::$users[$id]) ? new static(self::$users[$id]) : null;
    }
    public static function findIdentityByAccessToken($token, $type = null)	
    {    	
    $user = Usuario::findOne(['access_token' => $token]);     	
    if ($user) {      
    // Evita mostrar el token de usuario   	
    $user->access_token = null; 
    // Almacena el usuario en Yii::$app->user->identity  
    return new static($user);     	
    }     	
    return null; // Almacena null en Yii::$app->user->identity
        
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
            'estado' => 'Estado',
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

    /**
     * {@inheritdoc}
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * {@inheritdoc}
     */
    public function getAuthKey()
    {
        return $this->authKey;
    }

    /**
     * {@inheritdoc}
     */
    public function validateAuthKey($authKey)
    {
        return $this->authKey === $authKey;
    }

    /**
     * Validates password
     *
     * @param string $password password to validate
     * @return bool if password provided is valid for current user
     */
    public function validatePassword($password)
    {
        return $this->password === $password;
    }
}
