
/* by KI4LKF */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <time.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <string>
#include <set>
#include <map>
#include <utility>
#include <sys/sysinfo.h>

using namespace std;

static char DXRFD_VERSION[5] = "----";

#define VERSION "v1.20a" /* DO4iX */

// v1.20a - JSON Output, Jean, DO4iX
// v1.14i - Ramesh, Rich, Scott - 2013.01.28 - Consolidation of changes (get dxrfd ver# programatically; add dashboard and dxrfd rev# to the sub-header; remove dashboard ver # from footer
// v1.14g - Rich Painter - 2013.01.22 - Changed to common version.h, rm ver arg
// v1.14f - Ramesh, VA3UV - 2013.01.16 - Added struct sysinfo to get server uptime stats
// v1.14e - Ramesh, VA3UV - added new parameter agv[5] to pass dxrfd version # in xrf_lh call
//                          and display it on the dashboard in sub-header
// v1.14d - Ramesh, VA3UV - added dashboard s/w version on footer
// v1.14c - Rich Painter - modified date stamp to ISO format



// linked nodes
typedef set<string> linked_type;
static linked_type linked_list[5];  /* 0=A, 1=B, 2=C */
static linked_type::iterator linked_pos[5]; /* 0=A, 1=B, 2=C */
static char rptr_x[5][10];

// conected users
typedef set<string> connected_type;
static connected_type connected_list;
static connected_type::iterator connected_pos;

// last heard
typedef set<string> lh_type;
static lh_type lh_list;
static lh_type::reverse_iterator r_lh_pos;

static bool keep_running = true;
static int g2_sock = -1;
static unsigned char queryCommand[2048];
static struct sockaddr_in toLink;
static struct sockaddr_in fromLink;

static char temp_user[9];
static char *temp_user_p = NULL;

static bool srv_open(char *ip);
static void srv_close();
static void sigCatch(int signum);

/* signal catching function */
static void sigCatch(int signum)
{
   /* do NOT do any serious work here */
   if ((signum == SIGTERM) || (signum == SIGINT))
      keep_running = false;
   return;
}
      
static bool srv_open(char *ip)
{
   /* create our gateway socket */ 
   g2_sock = socket(PF_INET,SOCK_DGRAM,0);
   if (g2_sock == -1)
   {
      fprintf(stderr,"Failed to create gateway socket,errno=%d\n",errno);
      return false;
   }

   memset(&toLink,0,sizeof(struct sockaddr_in));
   toLink.sin_family = AF_INET;
   toLink.sin_addr.s_addr = inet_addr(ip);
   toLink.sin_port = htons(20001);

   return true;
}  

static void srv_close()
{
   if (g2_sock != -1)
      close(g2_sock);

   return;
}

int main(int argc, char **argv)
{
   fd_set fdset;
   struct timeval tv;
   socklen_t fromlen;
   int recvlen;
   short i = 0;
   unsigned short j;
   short k = -1;
   unsigned short max_index = 0;
   time_t init_rq;
   time_t tnow;
   short total_keepalive = 3;
   struct sigaction act; 
//   struct sysinfo sys_info;
   unsigned char *ptr = NULL;
 //  char *date_time = NULL;
   struct tm *mytm = NULL;
   char temp_string[64];

   setvbuf(stdout, (char *)NULL, _IOLBF, 0);
   fprintf(stderr, "VERSION %s\n", VERSION);

   if (argc != 5)
   {
      fprintf(stderr, "Usage: ./xrf_lh yourPersonalCallsign yourXRFreflector description IPaddressOF_XRF\n");
      return 1;
   }

   tzset();

   act.sa_handler = sigCatch;
   sigemptyset(&act.sa_mask);
   act.sa_flags = SA_RESTART;
   if (sigaction(SIGTERM, &act, 0) != 0)
   {
      fprintf(stderr, "sigaction-TERM failed, error=%d\n", errno);
      return 1;
   }
   if (sigaction(SIGINT, &act, 0) != 0)
   {
      fprintf(stderr,"sigaction-INT failed, error=%d\n", errno);
      return 1;
   }

   if (!srv_open((char *)argv[4]))
   {
      fprintf(stderr, "srv_open() failed\n");
      return 1;
   }

   /* initiate login */
   fprintf(stderr,"Requesting connection...\n");
   queryCommand[0] = 5;
   queryCommand[1] = 0;
   queryCommand[2] = 24;
   queryCommand[3] = 0;
   queryCommand[4] = 1;

   sendto(g2_sock,(char *)queryCommand,5,0,
             (struct sockaddr *)&toLink,
             sizeof(struct sockaddr_in));

   fcntl(g2_sock,F_SETFL,O_NONBLOCK);

   time(&init_rq);
   while (keep_running)
   {
      FD_ZERO(&fdset);
      FD_SET(g2_sock, &fdset);
      tv.tv_sec = 1;
      tv.tv_usec = 0;
      (void)select(g2_sock + 1, &fdset,0,0,&tv);

      if (FD_ISSET(g2_sock, &fdset))
      {
         fromlen = sizeof(struct sockaddr_in);
         recvlen = recvfrom(g2_sock,(char *)queryCommand, 2048,
                         0,(struct sockaddr *)&fromLink,&fromlen);

         /*** check that the incoming IP = outgoing IP ***/
         if (fromLink.sin_addr.s_addr != toLink.sin_addr.s_addr)
            continue;
      
         if ((recvlen == 3) &&
             (queryCommand[0] == 3) &&
             (queryCommand[1] == 96) &&
             (queryCommand[2] == 0))
         {
            sendto(g2_sock,(char *)queryCommand,3,0,
                (struct sockaddr *)&toLink,
                sizeof(struct sockaddr_in));

            total_keepalive--;
            if (total_keepalive == 0)
               break;
         }
         else
         if ((recvlen == 5) &&
             (queryCommand[0] == 5) &&
             (queryCommand[1] == 0) &&
             (queryCommand[2] == 24) &&
             (queryCommand[3] == 0) &&
             (queryCommand[4] == 1))
         {
            fprintf(stderr,"Connected...\n");
            memset(queryCommand, ' ', 2048);
            queryCommand[0] = 28;
            queryCommand[1] = 192;
            queryCommand[2] = 4;
            queryCommand[3] = 0;

            memcpy(queryCommand + 4, argv[1], strlen(argv[1]));
            for (j = 11; j > 3; j--)
            {
               if (queryCommand[j] == ' ')
                  queryCommand[j] = '\0';
               else
                  break;
            }
            memset(queryCommand + 12, '\0', 8);
            memcpy(queryCommand + 20, "DV019999", 8);

            sendto(g2_sock,(char *)queryCommand,28,0,
                (struct sockaddr *)&toLink,
                sizeof(struct sockaddr_in));
         }
         else
         if ((recvlen == 8) &&
             (queryCommand[0] == 8) &&
             (queryCommand[1] == 192) &&
             (queryCommand[2] == 4) &&
             (queryCommand[3] == 0))
         {
            if ((queryCommand[4] == 79) &&
                (queryCommand[5] == 75) &&
                (queryCommand[6] == 82))
            {
               fprintf(stderr,"Login OK, requesting gateway info...\n\n");

               /* request version */
               queryCommand[0] = 0x04;
               queryCommand[1] = 0xc0;
               queryCommand[2] = 0x03;
               queryCommand[3] = 0x00;
               sendto(g2_sock,(char *)queryCommand,4,0,
                      (struct sockaddr *)&toLink,
                      sizeof(struct sockaddr_in));

               /* request linked nodes */
               queryCommand[0] = 0x04;
               queryCommand[1] = 0xc0;
               queryCommand[2] = 0x05;
               queryCommand[3] = 0x00;
               sendto(g2_sock,(char *)queryCommand,4,0,
                      (struct sockaddr *)&toLink,
                      sizeof(struct sockaddr_in));

               /* request connected users */
               queryCommand[0] = 0x04;
               queryCommand[1] = 0xc0;
               queryCommand[2] = 0x06;
               queryCommand[3] = 0x00;
               sendto(g2_sock,(char *)queryCommand,4,0,
                      (struct sockaddr *)&toLink,
                      sizeof(struct sockaddr_in));

               /* request last-heard */
               queryCommand[0] = 0x04;
               queryCommand[1] = 0xc0;
               queryCommand[2] = 0x07;
               queryCommand[3] = 0x00;
               sendto(g2_sock,(char *)queryCommand,4,0,
                     (struct sockaddr *)&toLink,
                     sizeof(struct sockaddr_in));
            }
            else
            {
               fprintf(stderr,"Login failed\n");
               break;
            }
         }
         else
         if (recvlen > 8)
         {
            /* version */
            if ((queryCommand[2] == 0x03) &&
                (queryCommand[3] == 0x00))
            {
               memcpy(DXRFD_VERSION, queryCommand + 4, 4);
               DXRFD_VERSION[4] = '\0';
            }
            else
            /* connected users */
            if ((queryCommand[2] == 0x06) &&
                (queryCommand[3] == 0x00))
            {
               ptr = queryCommand + 8;
               while ((ptr - queryCommand) < recvlen)
               {
                  temp_string[0] = *ptr;
                  temp_string[1] = ':';
                  memcpy(temp_string + 2, ptr + 1, 8);
                  temp_string[10] = ':';
                  temp_string[11] = *(ptr + 10);
                  temp_string[12] = '\0';
                  if (!strstr(temp_string + 2, "1NFO"))
                     connected_list.insert(temp_string);
                  ptr += 20;
               }
            }
            else
            /* linked repeaters */
            if ((queryCommand[2] == 0x05) &&
                (queryCommand[3] == 0x01))
            {
               ptr = queryCommand + 8;
               while ((ptr - queryCommand) < recvlen)
               {
                  // get the repeater 
                  memcpy(temp_string, ptr + 1, 8);
                  temp_string[8] = '\0';

                  k = -1;
                  if (*ptr == 'A')
                     k = 0;
                  else
                  if (*ptr == 'B')
                     k = 1;
                  else
                  if (*ptr == 'C')
                     k = 2;
                  else
                  if (*ptr == 'D')
                     k = 3;
                  else
                  if (*ptr == 'E')
                     k = 4;
                    
                  if (k >= 0)
                     linked_list[k].insert(temp_string);
                  
                  ptr += 20;
               }
            }
            else
            /* last heard list */
            if ((queryCommand[2] == 0x07) &&
                (queryCommand[3] == 0x00) &&
                (recvlen > 10))
            {
               ptr = queryCommand + 10;
               while ((ptr - queryCommand) < recvlen)
               {
                  memset(temp_string, ' ', sizeof(temp_string));

                  tnow = *(uint32_t *)(ptr + 16);
                  mytm = localtime(&tnow);
                  sprintf(temp_string, "%02d%02d%02d-%02d:%02d:%02d",
                          mytm->tm_year % 100, mytm->tm_mon+1, mytm->tm_mday,
                          mytm->tm_hour,mytm->tm_min,mytm->tm_sec);
                  temp_string[15] = ' ';

                  memcpy(temp_string + 30, ptr + 8, 8);

                  strcpy(temp_string + 40,  (char *)ptr);

                  lh_list.insert(temp_string);
                  ptr += 24;
               }
            }
         }
         FD_CLR (g2_sock,&fdset);
      }
      time(&tnow);
      if ((tnow - init_rq) > 5)
      {
         fprintf(stderr, "timeout... is dxrfd running?\n");
         keep_running = false;
      }
   }

   printf("\{\n  \"Reflector\": \"%s\",\n", argv[3]);

   printf("  \"Linked Gateways\": \{ \n");

   max_index = linked_list[0].size();
   if (max_index < linked_list[1].size())
      max_index = linked_list[1].size();
   if (max_index < linked_list[2].size())
      max_index = linked_list[2].size();
   if (max_index < linked_list[3].size())
      max_index = linked_list[3].size();
   if (max_index < linked_list[4].size())
      max_index = linked_list[4].size();

   linked_pos[0] = linked_list[0].begin();
   linked_pos[1] = linked_list[1].begin();
   linked_pos[2] = linked_list[2].begin();
   linked_pos[3] = linked_list[3].begin();
   linked_pos[4] = linked_list[4].begin();

   if (max_index > 0)
   {
      printf("    \"A\": [\n");
      for (i = 0; i < max_index; i++)
      {
         if (linked_pos[0] != linked_list[0].end()) {
            strcpy(rptr_x[0], linked_pos[0]->c_str());
         printf("      {\"Callsign\": \"%s\"}", rptr_x[0]);
            linked_pos[0] ++;
         if (linked_pos[0] == linked_list[0].end()) 
           printf("\n");
         else
           printf(",\n");}

      } 
      printf("    ],\n");
      printf("    \"B\": [\n");
      for (i = 0; i < max_index; i++)
      {
         if (linked_pos[1] != linked_list[1].end()) { 
            strcpy(rptr_x[1], linked_pos[1]->c_str());
         printf("      {\"Callsign\": \"%s\"}", rptr_x[1]);
            linked_pos[1] ++;
         if (linked_pos[1] == linked_list[1].end()) 
           printf("\n");
         else
           printf(",\n");}
      }
      printf("    ],\n");
      printf("    \"C\": [\n");
      for (i = 0; i < max_index; i++)
      {
         if (linked_pos[2] != linked_list[2].end()) {
            strcpy(rptr_x[2], linked_pos[2]->c_str());
         printf("      {\"Callsign\": \"%s\"}", rptr_x[2]);
            linked_pos[2] ++;
         if (linked_pos[2] == linked_list[2].end()) 
           printf("\n");
         else
           printf(",\n");}
      }
      printf("    ],\n");
      printf("    \"D\": [\n");
      for (i = 0; i < max_index; i++)
      {
         if (linked_pos[3] != linked_list[3].end()) {
            strcpy(rptr_x[3], linked_pos[3]->c_str());
         printf("      {\"Callsign\": \"%s\"}", rptr_x[3]);
            linked_pos[3] ++;
         if (linked_pos[3] == linked_list[3].end()) 
           printf("\n");
         else
           printf(",\n");}
      }

      printf("    ],\n");
      printf("    \"E\": [\n");
      for (i = 0; i < max_index; i++)
      {
         if (linked_pos[4] != linked_list[4].end()) {
            strcpy(rptr_x[4], linked_pos[4]->c_str());
         printf("      {\"Callsign\": \"%s\"}", rptr_x[4]);
            linked_pos[4] ++;
         if (linked_pos[4] == linked_list[4].end()) 
           printf("\n");
         else
           printf(",\n");}
      }

      printf("    ]\n");
   }


   printf("  },\n");




   printf("  \"Software Clients\": \{\n    \"sitem\": [\n");

   for (connected_pos = connected_list.begin(); connected_pos!= connected_list.end(); connected_pos++)
   {
     printf("      {\"Callsign\": \"%.8s\", \"Module\": ", connected_pos->c_str() + 2);
     if ((connected_pos->c_str())[0] == ' ')
        printf("\"Listening\", ");
     else
        printf("\"%c\", ", (connected_pos->c_str())[0]);
     if ((connected_pos->c_str())[11] == 'H')
        printf("\"Type\": \"%s\"", "HotSpot");
     else
     if ((connected_pos->c_str())[11] == 'A')
        printf("\"Type\": \"%s\"", "DVAP");
     else
     if ((connected_pos->c_str())[11] == 'X')
        printf("\"Type\": \"%s\"", "DV Dongle");
     else
        printf("\"Type\": \"%s\"", "other");
     //printf("},\n");

     connected_pos++;
     if (connected_pos == connected_list.end()) 
     printf("}\n");
     else
     printf("},\n");
     connected_pos--;
   }

   printf("    ]\n  },");


// LAST HEARD


   printf("  \"Last Heard\": \{\n    \"litem\": [\n");

   for (r_lh_pos = lh_list.rbegin(); r_lh_pos != lh_list.rend(); r_lh_pos++)
   {
     memset(temp_user, ' ', 9); temp_user[8] = '\0';
     strncpy(temp_user, r_lh_pos->c_str() + 40, 8);
     temp_user_p = strchr(temp_user, ' ');
     if (temp_user_p)
     {
        *temp_user_p = '\0';

     }
     
     printf("      {\"Callsign\": \"%.8s\", ", r_lh_pos->c_str() + 40 );
     
     printf("\"Last TX on\": \"%.6s %c\", ", argv[2], *(r_lh_pos->c_str() + 37));
     printf("\"Source\": \"%.6s %c\", ", r_lh_pos->c_str() + 30, *(r_lh_pos->c_str() + 36)); 
     
	 char iso_date[12];
	 iso_date[0] = '2';
	 iso_date[1] = '0';
	 iso_date[2] = *(r_lh_pos->c_str() + 0);
	 iso_date[3] = *(r_lh_pos->c_str() + 1);
	 iso_date[4] = iso_date[7] = '-';
	 iso_date[5] = *(r_lh_pos->c_str() + 2);
	 iso_date[6] = *(r_lh_pos->c_str() + 3);
	 iso_date[8] = *(r_lh_pos->c_str() + 4);
	 iso_date[9] = *(r_lh_pos->c_str() + 5);
	 iso_date[10] = '\0';

	 printf("\"DateTime\": \"%s %.8s\"", iso_date, r_lh_pos->c_str()+7 );
//         printf(",\n");
     r_lh_pos++;
     if (r_lh_pos == lh_list.rend()) 
     printf("}\n");
     else
     printf("},\n");
     r_lh_pos--;

   }
   printf("    ]\n  }\n}\n");




   if (g2_sock != -1)
   {
      fprintf(stderr,"\nRequesting disconnect...\n");
      queryCommand[0] = 5;
      queryCommand[1] = 0;
      queryCommand[2] = 24;
      queryCommand[3] = 0;
      queryCommand[4] = 0;
      sendto(g2_sock,(char *)queryCommand,5,0,
          (struct sockaddr *)&toLink,
          sizeof(struct sockaddr_in));
   }
 
   srv_close();

   return 0;
}
