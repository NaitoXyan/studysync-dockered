<?php

namespace App\Http\Controllers;

use App\Models\Activity;
use App\Models\UserSubject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ActivityController extends Controller
{
    public function getAllActivitiesForUser($userId)
    {
        // Step 1: Get UserSubjects for the User
        $userSubjects = UserSubject::where('user_id', $userId)->get();
    
        // Step 2: Get all Activities for the UserSubjects with subject information
        $activities = collect();
    
        foreach ($userSubjects as $userSubject) {
            $activities = $activities->merge(
                Activity::where('subject_id', $userSubject->subject_id)
                    ->with('subject') // Eager load subject information
                    ->get()
            );
        }
    
        // Transform the activity to include subject_title instead of subject_id
        $transformedActivities = $activities->map(function ($activity) {
            return [
                'activity_id' => $activity['activity_id'],
                'activity_title' => $activity['activity_title'],
                'description' => $activity['description'],
                'deadline_day' => $activity['deadline_day'],
                'deadline_time' => $activity['deadline_time'],
                'subject_id' => $activity['subject']['subject_id'] ?? 'No Subject',
                'subject_title' => $activity['subject']['subject_title'] ?? 'No Subject'
            ];
        });
    
        return response()->json($transformedActivities);
    }

    public function addActivity(Request $request)
    {
        $validator = Validator::make($request->all(),[

            'activity_title' => 'required',
            'description' => 'required',
            'deadline_day' => 'required',
            'deadline_time' => 'required',
            'subject_id' => 'required'

        ]);
        
        if($validator->fails()) {

            return response()->json([

                'success' => false,

                'message' => $validator->errors()->first()

            ]);

        }

        $activity = Activity::create([

            'activity_title' => $request->activity_title,

            'description' => $request->description,

            'deadline_day' => $request->deadline_day,

            'deadline_time' => $request->deadline_time,

            'subject_id' => $request->subject_id

        ]);

        return response()->json([

            'success' => true,

            'message' => 'Activity added successfully.'

        ]);
    }

    public function updateActivity(Request $request, $activityId)
    {
        // Validate the request data
        $validator = Validator::make($request->all(), [

            'activity_title' => 'required',
            'description' => 'required',
            'deadline_day' => 'required',
            'deadline_time' => 'required',
            'subject_id' => 'required'

        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ]);
        }
    
        // Find the activity by ID
        $activity = Activity::find($activityId);
    
        if (!$activity) {
            return response()->json(['error' => 'Activity not found'], 404);
        }
    
        // Update the activity with the new data
        $activity->update([
            'activity_title' => $request->activity_title,

            'description' => $request->description,

            'deadline_day' => $request->deadline_day,

            'deadline_time' => $request->deadline_time,

            'subject_id' => $request->subject_id
        ]);
    
        return response()->json([
            'success' => true,
            'message' => 'Activity updated successfully.',
        ]);
    }

    public function deleteActivity($activityId)
    {
        // Find the act by ID
        $activity = Activity::find($activityId);
    
        if (!$activity) {
            // activity not found
            return response()->json(['message' => 'Activity not found.'], 404);
        }
    
        // Delete the activity
        $activity->delete();
    
        return response()->json([
            'success' => true,
            'message' => 'Activity deleted successfully.',
        ]);
    }

}
