<?php

namespace App\Models;

use App\Models\Subject;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Activity extends Model
{
    use HasFactory;

    protected $table = 'activity';
    protected $primaryKey = 'activity_id';

    // Disable automatic timestamp management
    public $timestamps = false;

    protected $fillable = [
        'activity_id',
        'activity_title',
        'description',
        'deadline_day',
        'deadline_time',
        'subject_id'
    ];

    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subject_id');
    }
}
