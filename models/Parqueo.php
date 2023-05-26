<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "parqueo".
 *
 * @property int $id
 * @property string $nombre
 * @property int $nro_plazas
 * @property int|null $plazas_disponibles
 * @property int|null $plazas_ocupadas
 *
 * @property Plaza[] $plazas
 */
class Parqueo extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'parqueo';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nombre', 'nro_plazas'], 'required'],
            [['nro_plazas', 'plazas_disponibles', 'plazas_ocupadas'], 'default', 'value' => null],
            [['nro_plazas', 'plazas_disponibles', 'plazas_ocupadas'], 'integer'],
            [['nombre'], 'string', 'max' => 80],
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
            'nro_plazas' => 'Nro Plazas',
            'plazas_disponibles' => 'Plazas Disponibles',
            'plazas_ocupadas' => 'Plazas Ocupadas',
        ];
    }

    /**
     * Gets query for [[Plazas]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getPlazas()
    {
        return $this->hasMany(Plaza::class, ['parqueo_id' => 'id']);
    }
}
