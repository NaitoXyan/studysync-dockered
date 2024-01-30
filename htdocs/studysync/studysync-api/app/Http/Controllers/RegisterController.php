<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Validator;

use Illuminate\Support\Facades\Hash;

use App\Models\User;

class RegisterController extends Controller

{

    // register api function

    public function register(Request $request) 

    {

        $validator = Validator::make($request->all(),[

            'name'     => 'required',

            'email'    => 'required',

            'password' => 'required'

        ]);

        if($validator->fails()) {

            return response()->json([

                'success' => false,

                'message' => $validator->errors()->first()

            ]);

        }

        $user = User::create([

            'name'     => $request->name,

            'email'    => $request->email,

            'password' => Hash::make($request->password),

        ]);

        $user->createToken('token')->accessToken;

        return response()->json([

            'success' => true,

            'message' => 'User register successfully.'

        ]);

    }

}
