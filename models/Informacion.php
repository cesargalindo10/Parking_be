<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "informacion".
 *
 * @property int $id
 * @property string $qr
 * @property string $atencion
 * @property string|null $foto
 * @property string $mensaje_mora
 * @property int $telefono
 */
class Informacion extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'informacion';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['qr', 'atencion', 'mensaje_mora', 'telefono'], 'required'],
            [['telefono'], 'default', 'value' => null],
            [['telefono'], 'integer'],
            [['qr', 'foto'], 'string', 'max' => 50],
            [['atencion'], 'string', 'max' => 100],
            [['mensaje_mora'], 'string', 'max' => 240],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'qr' => 'Qr',
            'atencion' => 'Atencion',
            'foto' => 'Foto',
            'mensaje_mora' => 'Mensaje Mora',
            'telefono' => 'Telefono',
        ];
    }
}
