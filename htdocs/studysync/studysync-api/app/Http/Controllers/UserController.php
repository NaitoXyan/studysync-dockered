<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function getUserSubjects($userId)
    {
    
     // Find the user by user_id
    $user = User::findOrFail($userId);

    // Get the subjects related to the user along with the subject titles
    $userSubjects = $user->userSubject->load('subject');

    // Extract subject information from the loaded subjects
    $subjectInfo = $userSubjects->map(function ($userSubject) {
        return [
            'id' => $userSubject->subject->subject_id,
            'title' => $userSubject->subject->subject_title,
        ];
    });

    // Return the subject information as JSON
    return response()->json($subjectInfo);
    }
}
