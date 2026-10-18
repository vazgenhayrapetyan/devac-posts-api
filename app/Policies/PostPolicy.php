<?php

namespace App\Policies;

use App\Models\Post;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class PostPolicy
{

    public function viewAny(User $user): bool
    {
        return in_array($user->role, ['user', 'admin', 'editor']);
    }

    public function view(User $user, Post $post): bool
    {
        return in_array($user->role, ['user', 'admin', 'editor']);
    }

    public function create(User $user): bool
    {
        return in_array($user->role, ['admin', 'editor']);
    }

    public function update(User $user, Post $post): bool
    {
        return in_array($user->role, ['admin', 'editor']);
    }

    public function delete(User $user, Post $post): bool
    {
        return $user->role === 'admin';
    }

    public function restore(User $user, Post $post): bool
    {
        return false;
    }

    public function forceDelete(User $user, Post $post): bool
    {
        return false;
    }
}
