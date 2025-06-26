<?php
// app/controller/UserController.php

namespace app\controller;

use support\Request;
use app\model\User;

class UserController
{
    public function index()
    {
        $users = User::select(); // ✅ Lấy toàn bộ user
        return json($users);
    }

    public function show($id)
    {
        $user = User::find($id); // ✅ Lấy user theo id
        if (!$user) {
            return response('Not found', 404);
        }
        return json($user);
    }

    public function store(Request $request)
    {
        $user = new User();
        $user->name = $request->post('name');
        $user->email = $request->post('email');
        $user->save();
        return json($user);
    }

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

