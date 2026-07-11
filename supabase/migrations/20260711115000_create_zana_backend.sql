create schema if not exists private;

revoke all on schema private from public, anon, authenticated;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null default '' check (char_length(first_name) <= 80),
  last_name text not null default '' check (char_length(last_name) <= 80),
  birth_date text not null default '' check (char_length(birth_date) <= 40),
  height text not null default '' check (char_length(height) <= 16),
  weight text not null default '' check (char_length(weight) <= 16),
  conditions text[] not null default '{}',
  screening_answers jsonb not null default '{}',
  agreed_privacy boolean not null default false,
  wearable_choice text check (wearable_choice is null or char_length(wearable_choice) <= 40),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

grant select, insert, update on public.profiles to authenticated;

create policy "Users can read their profile"
on public.profiles for select
to authenticated
using ((select auth.uid()) = id);

create policy "Users can create their profile"
on public.profiles for insert
to authenticated
with check ((select auth.uid()) = id);

create policy "Users can update their profile"
on public.profiles for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

create function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$;

revoke all on function private.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function private.handle_new_user();

create table public.medical_documents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  folder_id text not null check (folder_id in ('general', 'bloodwork', 'cardiology', 'dermatology', 'mentalhealth', 'dental')),
  display_name text not null check (char_length(display_name) between 1 and 160),
  storage_path text not null unique check (char_length(storage_path) <= 240),
  mime_type text not null check (mime_type in ('application/pdf', 'image/jpeg', 'image/png')),
  size_bytes bigint not null check (size_bytes between 1 and 10485760),
  document_date text not null default '' check (char_length(document_date) <= 40),
  created_at timestamptz not null default now()
);

create index medical_documents_user_created_idx
on public.medical_documents (user_id, created_at desc);

alter table public.medical_documents enable row level security;

grant select, insert, delete on public.medical_documents to authenticated;

create policy "Users can read their documents"
on public.medical_documents for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can create their documents"
on public.medical_documents for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can delete their documents"
on public.medical_documents for delete
to authenticated
using ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'medical-documents',
  'medical-documents',
  false,
  10485760,
  array['application/pdf', 'image/jpeg', 'image/png']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "Users can view their stored documents"
on storage.objects for select
to authenticated
using (
  bucket_id = 'medical-documents'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "Users can upload their stored documents"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'medical-documents'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "Users can delete their stored documents"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'medical-documents'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);
