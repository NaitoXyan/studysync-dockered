<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\ActivityController;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\ScheduleController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// sign up and login
Route::post('register', [RegisterController::class, 'register']);

Route::post('login', [LoginController::class, 'login']);

// for subject
Route::get('subject/{userId}', [UserController::class, 'getUserSubjects']);

Route::post('addSubject', [SubjectController::class, 'addSubject']);

Route::delete('subject/{subjectId}', [SubjectController::class, 'deleteSubject']);

// for schedule
Route::get('user/{userId}/schedules', [ScheduleController::class, 'getAllSchedulesForUser']);

Route::post('addSchedule', [ScheduleController::class, 'addSchedule']);

Route::put('schedule/{scheduleId}', [ScheduleController::class,'updateSchedule']);

Route::delete('deleteSchedule/{scheduleId}', [ScheduleController::class,'deleteSchedule']);

//for activity
Route::get('user/{userId}/activities', [ActivityController::class, 'getAllActivitiesForUser']);

Route::post('addActivity', [ActivityController::class, 'addActivity']);

Route::put('activity/{activityId}', [ActivityController::class,'updateActivity']);

Route::delete('deleteActivity/{activityId}', [ActivityController::class,'deleteActivity']);