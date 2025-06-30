<?php
// app/controller/UserController.php

namespace app\controller;

use support\Request;
use app\model\User;

/**
 * @OA\Info(
 *     title="Webman User API",
 *     version="1.0.0"
 * )
 * 
 * @OA\Tag(
 *     name="Users",
 *     description="Quản lý người dùng"
 * )
 */
class UserController
{
    /**
     * @OA\Get(
     *     path="/users",
     *     tags={"Users"},
     *     summary="Lấy danh sách người dùng",
     *     @OA\Response(
     *         response=200,
     *         description="Danh sách người dùng"
     *     )
     * )
     */
    public function index()
    {
        $users = User::select();
        return json($users);
    }

    /**
     * @OA\Get(
     *     path="/users/{id}",
     *     tags={"Users"},
     *     summary="Lấy chi tiết người dùng theo ID",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Thông tin người dùng"
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Không tìm thấy"
     *     )
     * )
     */
    public function show($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response('Not found', 404);
        }
        return json($user);
    }

    /**
     * @OA\Post(
     *     path="/users",
     *     tags={"Users"},
     *     summary="Tạo người dùng mới",
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"name", "email"},
     *             @OA\Property(property="name", type="string"),
     *             @OA\Property(property="email", type="string", format="email")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Người dùng đã tạo"
     *     )
     * )
     */
    public function store(Request $request)
    {
        $user = new User();
        $user->name = $request->post('name');
        $user->email = $request->post('email');
        $user->save();
        return json($user);
    }

    /**
     * @OA\Put(
     *     path="/users/{id}",
     *     tags={"Users"},
     *     summary="Cập nhật người dùng",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="name", type="string"),
     *             @OA\Property(property="email", type="string", format="email")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Đã cập nhật"
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Không tìm thấy"
     *     )
     * )
     */
    public function update(Request $request, $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response('Not found', 404);
        }
        $user->name = $request->post('name');
        $user->email = $request->post('email');
        $user->save();
        return json($user);
    }

    /**
     * @OA\Delete(
     *     path="/users/{id}",
     *     tags={"Users"},
     *     summary="Xoá người dùng",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Đã xoá"
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Không tìm thấy"
     *     )
     * )
     */
    public function destroy($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response('Not found', 404);
        }
        $user->delete();
        return json(['message' => 'Deleted']);
    }
}
