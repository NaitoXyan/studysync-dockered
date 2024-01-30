<?php

namespace App\Http\Controllers;

use App\Models\Schedule;
use App\Models\UserSubject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ScheduleController extends Controller
{
    public function getAllSchedulesForUser($userId)
    {
        // Step 1: Get UserSubjects for the User
        $userSubjects = UserSubject::where('user_id', $userId)->get();
    
        // Step 2: Get all Schedules for the UserSubjects with subject information
        $schedules = collect();
    
        foreach ($userSubjects as $userSubject) {
            $schedules = $schedules->merge(
                Schedule::where('subject_id', $userSubject->subject_id)
                    ->with('subject') // Eager load subject information
                    ->get()
            );
        }
    
        // Transform the schedules to include subject_title instead of subject_id
        $transformedSchedules = $schedules->map(function ($schedule) {
            return [
                'schedule_id' => $schedule['schedule_id'],
                'subject_id' => $schedule['subject']['subject_id'] ?? 'No Subject',
                'day' => $schedule['day'],
                'time_in' => $schedule['time_in'],
                'time_out' => $schedule['time_out'],
                'subject_title' => $schedule['subject']['subject_title'] ?? 'No Subject',
            ];
        });
    
        return response()->json($transformedSchedules);
    }

    public function addSchedule(Request $request)
    {
        $validator = Validator::make($request->all(),[

            'day' => 'required',
            'time_in' => 'required',
            'time_out' => 'required',
            'subject_id' => 'required'

        ]);
        
        if($validator->fails()) {

            return response()->json([

                'success' => false,

                'message' => $validator->errors()->first()

            ]);

        }

        $schedule = Schedule::create([

            'day' => $request->day,

            'time_in' => $request->time_in,

            'time_out' => $request->time_out,

            'subject_id' => $request->subject_id

        ]);

        return response()->json([

            'success' => true,

            'message' => 'Subject added successfully.'

        ]);
    }

    public function updateSchedule(Request $request, $scheduleId)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [
            'day' => 'required',
            'time_in' => 'required',
            'time_out' => 'required',
            'subject_id' => 'required',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ]);
        }
    
        // Find the schedule by ID
        $schedule = Schedule::find($scheduleId);
    
        if (!$schedule) {
            return response()->json(['error' => 'Schedule not found'], 404);
        }
    
        // Update the schedule with the new data
        $schedule->update([
            'day' => $request->day,
            'time_in' => $request->time_in,
            'time_out' => $request->time_out,
            'subject_id' => $request->subject_id,
        ]);
    
        return response()->json([
            'success' => true,
            'message' => 'Schedule updated successfully.',
        ]);
    }

    public function deleteSchedule($scheduleId)
    {
        // Find the schedule by ID
        $schedule = Schedule::find($scheduleId);
    
        if (!$schedule) {
            // Schedule not found
            return response()->json(['message' => 'Schedule not found.'], 404);
        }
    
        // Delete the schedule
        $schedule->delete();
    
        return response()->json([
            'success' => true,
            'message' => 'Schedule deleted successfully.',
        ]);
    }
}
