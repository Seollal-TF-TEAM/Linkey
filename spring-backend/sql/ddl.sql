-- users 테이블 생성
CREATE TABLE users (
                       github_user_id BIGINT PRIMARY KEY,
                       github_user_name VARCHAR,
                       github_user_email VARCHAR,
                       github_repos_url VARCHAR,
                       github_updated_at TIMESTAMP,
                       created_at TIMESTAMP DEFAULT now(),
                       updated_at TIMESTAMP DEFAULT now()
);

-- team_members 테이블 생성 및 team_seq_id 시퀀스 설정
CREATE SEQUENCE team_members_team_seq_id START 1;

CREATE TABLE team_members (
                              team_seq_id INTEGER DEFAULT nextval('team_members_team_seq_id'),
                              team_id INTEGER NOT NULL,
                              team_name VARCHAR,
                              member_role VARCHAR, -- ENUM 타입을 VARCHAR로 정의, 필요시 ENUM 타입을 별도로 생성 가능
                              github_user_id BIGINT NOT NULL REFERENCES users(github_user_id),
                              created_at TIMESTAMP DEFAULT now(),
                              updated_at TIMESTAMP DEFAULT now(),
                              PRIMARY KEY (team_id, team_seq_id)
);

ALTER SEQUENCE team_members_team_seq_id OWNED BY team_members.team_seq_id;

-- projects 테이블 생성 및 project_id 시퀀스 설정
CREATE SEQUENCE projects_project_id_seq START 1;

CREATE TABLE projects (
                          project_id INTEGER PRIMARY KEY DEFAULT nextval('projects_project_id_seq'),
                          project_name VARCHAR,
                          project_desc VARCHAR,
                          team_id INTEGER NOT NULL REFERENCES team_members(team_id),
                          created_at TIMESTAMP DEFAULT now(),
                          updated_at TIMESTAMP DEFAULT now()
);

ALTER SEQUENCE projects_project_id_seq OWNED BY projects.project_id;

-- sprints 테이블 생성 및 sprint_id 시퀀스 설정
CREATE SEQUENCE sprints_sprint_id_seq START 1;

CREATE TABLE sprints (
                         sprint_id INTEGER PRIMARY KEY DEFAULT nextval('sprints_sprint_id_seq'),
                         sprint_name VARCHAR,
                         sprint_contents VARCHAR,
                         project_id INTEGER NOT NULL REFERENCES projects(project_id),
                         sprint_start_at DATE,
                         sprint_end_at DATE,
                         created_at TIMESTAMP DEFAULT now(),
                         updated_at TIMESTAMP DEFAULT now()
);

ALTER SEQUENCE sprints_sprint_id_seq OWNED BY sprints.sprint_id;

-- todos 테이블 생성 및 todo_id 시퀀스 설정
CREATE SEQUENCE todos_todo_id_seq START 1;

CREATE TABLE todos (
                       todo_id INTEGER PRIMARY KEY DEFAULT nextval('todos_todo_id_seq'),
                       todo_contents VARCHAR,
                       todo_done_yn CHAR(1) DEFAULT 'N',
                       sprint_id INTEGER NOT NULL REFERENCES sprints(sprint_id),
                       created_user_id BIGINT NOT NULL REFERENCES users(github_user_id),
                       created_at TIMESTAMP DEFAULT now(),
                       updated_at TIMESTAMP DEFAULT now()
);

ALTER SEQUENCE todos_todo_id_seq OWNED BY todos.todo_id;

-- commits 테이블 생성 및 commit_id 시퀀스 설정
CREATE SEQUENCE commits_commit_id_seq START 1;

CREATE TABLE commits (
                         commit_id INTEGER PRIMARY KEY DEFAULT nextval('commits_commit_id_seq'),
                         github_commit_sha VARCHAR NOT NULL,  -- commit ID
                         github_commit_message TEXT NOT NULL, -- commit message
                         github_commit_user_id BIGINT NOT NULL, -- committer ID (FK 아님)
                         github_commit_date TIMESTAMP NOT NULL, -- commit 날짜
                         todo_id INTEGER NOT NULL REFERENCES todos(todo_id), -- FK (todos.todo_id)
                         created_at TIMESTAMP DEFAULT now(),
                         updated_at TIMESTAMP DEFAULT now()
);

ALTER SEQUENCE commits_commit_id_seq OWNED BY commits.commit_id;
