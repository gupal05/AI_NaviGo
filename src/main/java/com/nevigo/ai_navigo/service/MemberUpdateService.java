package com.nevigo.ai_navigo.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberUpdateService {
    @Autowired
    private MemberRepository memberRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public void updateMember(String username, Member updatedMember, String currentPassword) {
        // 현재 사용자 조회
        Member existingMember = memberRepository.findByUsername(username)
                .orElseThrow(() -> new UserNotFoundException("사용자를 찾을 수 없습니다."));

        // 현재 비밀번호 검증
        if (!passwordEncoder.matches(currentPassword, existingMember.getPassword())) {
            throw new InvalidPasswordException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 업데이트 가능한 정보 설정
        existingMember.setEmail(updatedMember.getEmail());
        existingMember.setPhone(updatedMember.getPhone());

        // 새 비밀번호가 있는 경우에만 비밀번호 변경
        if (StringUtils.hasText(updatedMember.getNewPassword())) {
            existingMember.setPassword(
                    passwordEncoder.encode(updatedMember.getNewPassword())
            );
        }

        memberRepository.save(existingMember);
    }
}
