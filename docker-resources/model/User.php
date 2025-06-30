<?php
namespace app\model;

use think\Model;

class User extends Model
{
    protected $table = 'users';
    public $timestamps = false;
    protected $fillable = ['name', 'email'];
}
