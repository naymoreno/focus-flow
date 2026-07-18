-- Run this in the Supabase SQL Editor for project cacrnxpwycuplnlrzprf

create table if not exists public.user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  sched jsonb,
  checks jsonb default '{}'::jsonb,
  wins jsonb default '{}'::jsonb,
  streaks jsonb default '{}'::jsonb,
  lists jsonb,
  bdays jsonb default '[]'::jsonb,
  library jsonb default '{}'::jsonb,
  badges jsonb default '{}'::jsonb,
  updated_at timestamptz default now()
);

alter table public.user_data enable row level security;

create policy "Users read own data"
  on public.user_data for select
  using (auth.uid() = user_id);

create policy "Users insert own data"
  on public.user_data for insert
  with check (auth.uid() = user_id);

create policy "Users delete own data"
  on public.user_data for delete
  using (auth.uid() = user_id);

create policy "Users update own data"
  on public.user_data for update
  using (auth.uid() = user_id);

-- Lets signed-in users permanently delete their auth account (user_data cascades).
create or replace function public.delete_user_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

grant execute on function public.delete_user_account() to authenticated;
