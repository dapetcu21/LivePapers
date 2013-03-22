#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netdb.h>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <unistd.h>
#include <vector>
#include <poll.h>
#include <signal.h>

#define LISTEN_PORT "3969"
#define DEFAULT_MESSAGE 0

struct connection
{
    int socket;
    enum states
    {
        stateAccepted,
        stateSending,
    } state;
};

uint8_t message = DEFAULT_MESSAGE; 
long long unsigned hits = 0;

void print_info(int sig)
{
    printf("Number of hits: %llu\n", hits);
}

void reset_hits(int sig)
{
    hits = 0;
    printf("Hit count reset\n");
}

void increment_message(int sig)
{
    message++;
    printf("Message incremented: %hhu\n", message);
}

int main(int argc, const char * argv[])
{
    
    if (argc >= 2)
        sscanf(argv[1], "%hhu", &message);

    printf("Running with message: %hhu\n", message);

    signal(SIGINT, &print_info);
    signal(SIGUSR1, &reset_hits);
    signal(SIGUSR2, &increment_message);

    struct addrinfo hints, *res,*p;
    int sockfd;
    std::vector<int> socks;

    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;

    std::vector<struct pollfd> poll_q;
    std::vector<struct connection> connections;

    int r;
    if ((r = getaddrinfo(NULL, LISTEN_PORT, &hints, &res))!=0)
    {
        fprintf(stderr,"getaddrinfo: %s",gai_strerror(r));
        return -1;
    }

    for (p=res; p; p=p->ai_next)
    {
        if ((sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol))<0)
            continue;
        
        if (fcntl(sockfd, F_SETFL, O_NONBLOCK)<0)
        {
            close(sockfd);
            continue;
        }
        
        if (bind(sockfd, res->ai_addr, res->ai_addrlen)<0)
        {
            close(sockfd);
            continue;
        }

        if (listen(sockfd, 100)<0)
        {
            close(sockfd);
            continue;
        }

        fcntl(sockfd, F_SETFL, SO_REUSEADDR);
        
        struct pollfd pfd = {
            .fd = sockfd,
            .events = POLLIN,
            .revents = 0,
        };
        socks.push_back(sockfd);
        poll_q.push_back(pfd);
    }

    if (!socks.size())
    {
        fprintf(stderr,"no valid interfaces to listen on found\n");
        return -1;
    }

    while (socks.size())
    {
        poll(&poll_q[0], poll_q.size(), -1);
        for (size_t i = 0; i < socks.size(); i ++)
        {
            int flags = poll_q[i].revents;
            if (flags & POLLHUP)
            {
                close(socks[i]);
                poll_q.erase(poll_q.begin() + i);
                socks.erase(socks.begin() + i);
                i--;
                continue;
            }
            if (flags & POLLIN)
            {
                struct sockaddr_storage addr;
                socklen_t len = sizeof(addr);
                int sock = accept(socks[i], (struct sockaddr *)&addr, &len);
                if (sock != -1)
                {
                    hits++;
                    struct connection conn = {
                        .socket = sock,
                        .state = connection::stateAccepted,
                    };
                    struct pollfd pfd = {
                        .fd = sock,
                        .events = POLLOUT,
                        .revents = 0
                    };
                    connections.push_back(conn);
                    poll_q.push_back(pfd);
                }
            }
        }
        for (size_t i = 0; i < connections.size(); i++)
        {
            int pi = i + socks.size();
            int flags = poll_q[pi].revents;
            if ((flags & POLLHUP) || ((flags & POLLOUT) && connections[i].state == connection::stateSending))
            {
                close(connections[i].socket);
                connections.erase(connections.begin() + i);
                poll_q.erase(poll_q.begin() + pi);
                i--;
            } else 
            if (flags & POLLOUT)
            {
                uint8_t mv[] = { message };
                write(connections[i].socket, (const void*)mv, sizeof(mv));
                connections[i].state = connection::stateSending;
            }
        }
    }
    return 0;
}
