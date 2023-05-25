<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "turno".
 *
 * @property string $nombre
 * @property string $hora_inicio
 * @property string $hora_fin
 * @property int $id
 *
 * @property TurnoUsuario[] $turnoUsuarios
 */
class Turno extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'turno';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nombre', 'hora_inicio', 'hora_fin'], 'required'],
            [['hora_inicio', 'hora_fin'], 'safe'],
            [['nombre'], 'string', 'max' => 20],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'nombre' => 'Nombre',
            'hora_inicio' => 'Hora Inicio',
            'hora_fin' => 'Hora Fin',
            'id' => 'ID',
        ];
    }

    /**
     * Gets query for [[TurnoUsuarios]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getTurnoUsuarios()
    {
        return $this->hasMany(TurnoUsuario::class, ['turno_id' => 'id']);
    }
}
