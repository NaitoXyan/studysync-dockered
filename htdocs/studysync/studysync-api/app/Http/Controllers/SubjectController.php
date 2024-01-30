<?php

namespace App\Http\Controllers;

use App\Models\Subject;
use App\Models\UserSubject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SubjectController extends Controller
{
    public function addSubject(Request $request)
    {

        $validator = Validator::make($request->all(),[

            'subject_title' => 'required',

            'user_id' => 'required'

        ]);
        
        if($validator->fails()) {

            return response()->json([

                'success' => false,

                'message' => $validator->errors()->first()

            ]);

        }

        // add to row
        $subject = Subject::create([

            'subject_title' => $request->subject_title

        ]);

        $subjectId = $subject->subject_id;

        $userSubject = UserSubject::create([

            'user_id' => $request->user_id,

            'subject_id' => $subjectId

        ]);

        return response()->json([

            'success' => true,

            'message' => 'Subject added successfully.'

        ]);
    }

    public function deleteSubject($subjectId)
    {

        // Find the subject by ID
        $subject = Subject::find($subjectId);

        if (!$subject) {
            // Subject not found
            return response()->json(['message' => 'Subject not found.'], 404);
        }

        // Delete the subject
        $subject->delete();

        return response()->json(['message' => 'Subject deleted successfully.']);

    }
}
