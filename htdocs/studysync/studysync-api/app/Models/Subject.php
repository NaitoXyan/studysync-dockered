<?php

namespace App\Models;

use App\Models\Schedule;
use App\Models\UserSubject;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Subject extends Model
{
    use HasFactory;

    protected $table = 'subject';
    protected $primaryKey = 'subject_id';

    // Disable automatic timestamp management
    public $timestamps = false;

    protected $fillable = [
        'subject_id',
        'subject_title'
    ];

    public function userSubject()
    {
        return $this->hasMany(UserSubject::class, 'subject_id');
    }

    public function schedule()
    {
        return $this->hasMany(Schedule::class, 'subject_id');
    }

    public function activity()
    {
        return $this->hasMany(Activity::class, 'subject_id');
    }
}
