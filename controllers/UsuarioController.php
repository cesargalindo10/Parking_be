<?php

namespace app\controllers;

use app\models\Cliente;
use app\models\User;
use app\models\Usuario;
use Yii;
use Exception;
use yii\data\Pagination;
use yii\db\IntegrityException;
use yii\rbac\Role;

class UsuarioController extends \yii\web\Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['verbs'] = [
            'class' => \yii\filters\VerbFilter::class,
            'actions' => [
                'create-user' => ['POST'],
                'update-user' => ['POST'],
                'login' => ['POST']

            ]
        ];
        /*$behaviors['authenticator'] = [
            'class' => \yii\filters\auth\HttpBearerAuth::class,
            'except' => ['options','login','create-client']
        ];*/
        return $behaviors;
    }

    public function beforeAction($action)
    {
        if (Yii::$app->getRequest()->getMethod() === 'OPTIONS') {
            Yii::$app->getResponse()->getHeaders()->set('Allow', 'POST GET PUT');
            Yii::$app->end();
        }
        $this->enableCsrfValidation = false;
        Yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
        return parent::beforeAction($action);
    }

    public function actionCreateUser()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = new Usuario();
        $user->password_hash = Yii::$app->getSecurity()->generatePasswordHash($params["password"]);
        $user->access_token = Yii::$app->security->generateRandomString();
        $user->load($params, "");
        $cli = Cliente::find()->where(['email' => $params["email"]])->one();
        if ($cli) {
            $response = [
                'success' => false,
                'message' => 'Usuario con email ya existe',

            ];
        } else {
            try {
                if ($user->save()) {
                    $auth = Yii::$app->authManager;
                    $role = $auth->getRole($params['rol']);
                    $auth->assign($role, $user->id);
                    Yii::$app->getResponse()->getStatusCode(201);
                    $response = [
                        'success' => true,
                        'message' => 'Usuarion se creo con Exito',
                        'data' => $user
                    ];
                } else {
                    Yii::$app->getResponse()->getStatusCode(222, 'La validacion de datos a fallado');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al crear usuario',
                        'data' => $user->errors
                    ];
                }
            } catch (Exception $e) {

                //Yii::$app->getResponse()->getStatusCode(500);
                $response = [
                    'success' => false,
                    'message' => 'ocurrio un error al crear usuario',
                    'data' => $e->getMessage()
                ];
            }
        }
        return $response;
    }
    public function actionTest(){
        $params = Yii::$app->getRequest()->getBodyParams();
        $cli = Cliente::find()->where(['email' => $params["email"]])->one();  
        return $cli;
    }
    public function actionIndex($pageSize = 5)
    {
        $query = Usuario::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $users = $query
            ->orderBy('id DESC')
            ->offset($pagination->offset)
            ->limit($pagination->limit)
            ->all();

        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
            'success' => true,
            'message' => 'lista de clientes',
            'pageInfo' => [
                'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
                'previus' => $currentPage == 1 ? null : $currentPage - 1,
                'count' => count($users),
                'page' => $currentPage,
                'start' => $pagination->getOffset(),
                'totalPages' => $totalPages,
                'users' => $users
            ]
        ];
        return $response;
    }
    public function actionUpdateUser($idUser)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = Usuario::findOne($idUser);
        $auth = Yii::$app->authManager;
        $roleP = $auth->getRole($params['rol']);
        $roleDelete = $auth->getRolesByUser($idUser);
        $cli = Cliente::find()->where(['email' => $params])->one();
        if ($cli) {
            $response = [
                'success' => false,
                'message' => 'Usuario con email ya existe',

            ];
        } else {
            if ($user) {

                try {
                    $user->load($params, '');

                    if (isset($params['password'])) {
                        $user->password_hash = Yii::$app->getSecurity()->generatePasswordHash($params["password"]);
                    }
                    if ($roleDelete) {
                        foreach ($roleDelete as $role) {
                            $auth->revoke($role, $idUser);
                        }
                        $auth->assign($roleP, $idUser);
                    }


                    if ($user->save()) {
                        $response = [
                            'success' => true,
                            'message' => 'Se actualizó el usuario correctamente',
                            'data' => $user
                        ];
                    } else {
                        Yii::$app->getResponse()->setStatusCode(422, 'La validación de datos ha fallado.');
                        $response = [
                            'success' => false,
                            'message' => 'Fallo al actualizar el usuario',
                            'data' => $user->errors
                        ];
                    }
                } catch (Exception $e) {
                    $response = [
                        'success' => false,
                        'message' => 'Error al actualizar',
                        'data' => $e->getMessage()
                    ];
                }
            } else {
                Yii::$app->getResponse()->setStatusCode(404);
                $response = [
                    'success' => false,
                    'message' => 'Usuario no encontrado',
                ];
            }
        }



        return $response;
    }
    public function actionRemoveUserRole($userId, $roleName)
    {
        $auth = Yii::$app->authManager;

        // Obtener el usuario y el rol correspondiente
        $user = Usuario::findOne($userId);
        $role = $auth->getRole($roleName);

        if ($user && $role) {
            // Revocar el rol del usuario
            $auth->revoke($role, $userId);

            return [
                'success' => true,
                'message' => 'Asignación de rol eliminada correctamente',
            ];
        }

        return [
            'success' => false,
            'message' => 'No se encontró el usuario o el rol',
        ];
    }


    public function actionDelete($idUser)
    {

        $user = Usuario::findOne($idUser);
        if ($user) {
            try {
                $user->delete();
                $response = [
                    'success' => true,
                    'message' => 'Usuario eliminado '
                ];
            } catch (IntegrityException $ie) {
                Yii::$app->getResponse()->setStatusCode(409);
                $response = [
                    'success' => false,
                    'message' => 'El user esta siendo usado',
                    'code' => $ie->getCode()
                ];
            } catch (Exception $e) {
                Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado');
                $response = [
                    'success' => false,
                    'message' => $e->getMessage(),
                    'code' => $e->getCode()
                ];
            }
        } else {
            Yii::$app->getResponse()->getStatusCode(404);
            $response = [
                'success' => false,
                'message' => 'usuario no encontrado',

            ];
        }
        return $response;
    }
    public function actionGetUsers()
    {
        $users = Usuario::find()->all();
        // $auth = Yii::$app->authManager;
        // $role = $auth->getRole();
        //$auth -> assign($role, $user -> id);
        return $users;
    }
    public function actionLogin()
    {

        $params = Yii::$app->getRequest()->getBodyParams();
        try {
            $username = isset($params['email']) ? $params['email'] : null;
            $pwd = isset($params['password']) ? $params['password'] : null;

            $user = Usuario::findOne(['email' => $username]);
            $auth = Yii::$app->authManager;
            $client = Cliente::findOne(['email' => $username]);
            if ($user) {
                // Verificamos la contraseña
                if (Yii::$app->security->validatePassword($pwd, $user->password_hash)) {
                    $role = $auth->getRolesByUser($user->id);
                    $permission = $auth->getPermissionsByUser($user->id);
                    $response = [
                        "success" => true,
                        "message" => "Inicio de sesión exitoso",
                        "accessToken" => $user->access_token,
                        "rol" => $role,
                        "permission" => $permission,
                        "id" => $user->id,
                        "nombre" => $user->nombre

                    ];
                    return $response;
                }
            } else
            if ($client) {
                // Verificamos la contraseña
                if (Yii::$app->security->validatePassword($pwd, $client->password_hash)) {
                    $role = $auth->getRolesByUser($client->id);
                    $response = [
                        "success" => true,
                        "message" => "Inicio de sesión exitoso",
                        "accessToken" => $client->access_token,
                        "rol" => $role,
                        "id" => $client->id,
                        "nombre" => $client->nombre_completo

                    ];
                    return $response;
                }
            }
            Yii::$app->getResponse()->setStatusCode(400);
            $response = [
                "succes" => false,
                "message" => "Usuario y/o Contraseña incorrecto."
            ];
        } catch (Exception $e) {
            Yii::$app->getResponse()->setStatusCode(500);
            $response = [
                'success' => false,
                'message' => $e->getMessage(),
                'code' => $e->getCode(),
            ];
        }
        return $response;
    }
    public function actionCreateClient()
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $user = new Cliente();
        $user->password_hash = Yii::$app->getSecurity()->generatePasswordHash($params["password"]);
        $user->access_token = Yii::$app->security->generateRandomString();
        $user->rol = "cliente";
        $user->load($params, "");
        try {
            if ($user->save()) {
                $auth = Yii::$app->authManager;
                $role = $auth->getRole('cliente');
                $auth->assign($role, $user->id);
                Yii::$app->getResponse()->getStatusCode(201);
                $response = [
                    'success' => true,
                    'message' => 'Cliente se creo con Exito',
                    'data' => $user
                ];
            } else {
                Yii::$app->getResponse()->getStatusCode(222, 'La validacion de datos a fallado');
                $response = [
                    'success' => false,
                    'message' => 'fallo al crear cliente',
                    'data' => $user->errors
                ];
            }
        } catch (Exception $e) {

            Yii::$app->getResponse()->getStatusCode(500);
            $response = [
                'success' => false,
                'message' => 'ocurrio un error al crear cliente',
                'data' => $e->getMessage()
            ];
        }
        return $response;
    }
    public function actionUpdateCustomer($id)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $customer = Cliente::findOne($id);
        if ($customer) {
            $customer->load($params, '');
            try {
                if ($customer->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el usuario de manera correcta',
                        'data' => $customer
                    ];
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar usuario',
                        'data' => $customer->errors
                    ];
                }
            } catch (Exception $e) {
                $response = [
                    'success' => false,
                    'message' => 'Error al actualizar',
                    'data' => $e->getMessage()
                ];
            }
        } else {
            Yii::$app->getResponse()->getStatusCode(404);
            $response = [
                'success' => false,
                'message' => 'user no encontrado',

            ];
        }

        return $response;
    }
    public function actionDisableClient($id)
    {
        $cliente = Cliente::findOne($id);
        if ($cliente) {

            $cliente->estado = !$cliente->estado;
            try {
                if ($cliente->save()) {
                    $response = [
                        'success' => true,
                        'message' => 'se actualizo el cliente de manera correcta',
                        'data' => $cliente
                    ];
                } else {
                    Yii::$app->getResponse()->setStatusCode(422, 'La validacion de datos a fallado.');
                    $response = [
                        'success' => false,
                        'message' => 'fallo al actualizar cliente',
                        'data' => $cliente->errors
                    ];
                }
            } catch (Exception $e) {
                $response = [
                    'success' => false,
                    'message' => 'Error al actualizar',
                    'data' => $e->getMessage()
                ];
            }
        } else {
            $response = [
                'success' => false,
                'message' => 'Cliente no encontrado',

            ];
        }
        return $response;
    }

    public function actionGetClients($pageSize = 5)
    {
        $query = Cliente::find();

        $pagination = new Pagination([
            'defaultPageSize' => $pageSize,
            'totalCount' => $query->count(),
        ]);

        $customers = $query
            ->orderBy('id DESC')
            ->offset($pagination->offset)
            ->limit($pagination->limit)
            ->all();

        $currentPage = $pagination->getPage() + 1;
        $totalPages = $pagination->getPageCount();
        $response = [
            'success' => true,
            'message' => 'lista de clientes',
            'pageInfo' => [
                'next' => $currentPage == $totalPages ? null  : $currentPage + 1,
                'previus' => $currentPage == 1 ? null : $currentPage - 1,
                'count' => count($customers),
                'page' => $currentPage,
                'start' => $pagination->getOffset(),
                'totalPages' => $totalPages,
                'customers' => $customers
            ]
        ];
        return $response;
    }

    public function actionCreateRol($nombre)
    {
        $params = Yii::$app->getRequest()->getBodyParams();
        $role = new Role();
        $role->name = $nombre;
        $roleDesc = ucfirst($nombre);
        $role->description = $roleDesc;
        $auth = Yii::$app->authManager;
        if ($auth->add($role)) {
            $response = [
                'success' => true,
                'message' => 'Rol se creo con Exito',
            ];
            $this->actionAsignarPermissionToRol($nombre, $params);
        } else {
            $response = [
                'success' => true,
                'message' => 'Error al crear rol',
            ];
        }
        return $response;
    }
    public function actionAsignarPermisos()
    {
        $auth = Yii::$app->authManager;
        $permission = $auth->getPermission('parqueo');
        $auth->assign($permission, 5); // Asigna el permiso crearUsuarios al usuario con ID 6

    }
    public function actionAsignarPermissionToRol($nombreR, $params)
    {

        // $params = ['dashboard', 'parqueo', 'informacion','usuarios','solicitud','tarifas','reclamos','plazas','customers','asignar','reportes','mora','roles'];
        $authManager = Yii::$app->authManager;
        $rol = $authManager->getRole($nombreR);
        foreach ($params as $nombrePermiso) {
            $permiso = $authManager->getPermission($nombrePermiso);
            $authManager->addChild($rol, $permiso);
        }
    }
    public function actionGetRoles()
    {
        $authManager = Yii::$app->authManager;
        $roles = $authManager->getRoles();
        if ($roles) {
            $response = [
                'success' => true,
                'message' => "El rol ha sido eliminado correctamente.",
                'roles' => $roles
            ];
        } else {
            $response = [
                'success' => false,
                'message' => "No hay Roles"
            ];
        }
        return $response;
    }
    public function actionDeleteRol($nombre)
    {
        // Elimina el rol
        $authManager = Yii::$app->authManager;
        $rol = $authManager->getRole($nombre);
        if ($rol !== null) {
            $authManager->remove($rol);
            $response = [
                'success' => true,
                'message' => "El rol ha sido eliminado correctamente."
            ];
        } else {
            $response = [
                'success' => false,
                'message' => "Fallo al eliminar Rol"
            ];
        }
        return $response;
    }
}
