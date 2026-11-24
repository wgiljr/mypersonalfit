-- MYP-6 proof of concept: temporary table that mirrors the app's current Swift `Workout`.
-- Not the real schema (see docs/domain.md; MYP-10 creates it). Drop this table when MYP-10 lands.
-- Run in the Supabase dashboard: SQL Editor -> New query -> paste -> Run.

create table if not exists public.workouts (
    id                 text primary key,
    title              text not null,
    duration_minutes   integer not null check (duration_minutes > 0),
    level              text not null check (level in ('beginner', 'intermediate', 'advanced')),
    category           text not null check (category in ('strength', 'cardio', 'core', 'mobility')),
    estimated_calories integer not null,
    trainer_name       text not null,
    image_name         text not null,
    sort_order         integer not null default 0
);

-- RLS on, with a read-only policy for the anon key. No insert/update/delete policies,
-- so the app can only read. Real policies (scoped by trainer) come with MYP-10.
alter table public.workouts enable row level security;

-- New Supabase projects don't grant table access to the API roles by default.
-- The grant lets the role reach the table; the RLS policy below decides which rows it sees.
grant select on public.workouts to anon, authenticated;

drop policy if exists "PoC: anyone can read workouts" on public.workouts;
create policy "PoC: anyone can read workouts"
    on public.workouts for select
    to anon, authenticated
    using (true);

insert into public.workouts
    (id, title, duration_minutes, level, category, estimated_calories, trainer_name, image_name, sort_order)
values
    ('full-body-30',  'Full Body',  30, 'intermediate', 'strength', 320, 'Alex Rivera', 'WorkoutFullBody',  0),
    ('lower-body-25', 'Lower Body', 25, 'beginner',     'strength', 240, 'Sam Carter',  'WorkoutLowerBody', 1),
    ('core-25',       'Core',       25, 'beginner',     'core',     180, 'Jordan Lee',  'WorkoutCore',      2)
on conflict (id) do nothing;
