<?php

namespace App\Http\Controller;

use Illuminate\Http\Request;

class UserController extends Controller
{
    //
    function testReuest(Request $req)
    {
        return "hello from controller";
    } 

}
