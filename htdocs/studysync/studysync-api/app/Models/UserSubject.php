<?php

namespace App\Models;

use App\Models\User;
use App\Models\Subject;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UserSubject extends Model
{
    use HasFactory;

    protected $table = 'user-subject';
    protected $primaryKey = ['user_id', 'subject_id'];
    public $incrementing = false;

    // Disable automatic timestamp management
    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'subject_id',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subject_id');
    }
}
